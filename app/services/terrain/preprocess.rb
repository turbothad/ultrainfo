require "net/http"
require "open3"

module Terrain
  # Builds a static terrain artifact from public Mapzen/Tilezen Terrarium DEM tiles.
  # The browser renderer consumes the committed JSON artifact, so page load does
  # not depend on fetching elevation tiles.
  class Preprocess
    TILE_SIZE = 256
    TILE_URL = "https://s3.amazonaws.com/elevation-tiles-prod/terrarium/%<z>d/%<x>d/%<y>d.png"
    FT_PER_M = 3.28084

    def initialize(race, output_path:, zoom: 11, grid_size: 96, cache_dir: Rails.root.join("tmp/terrain_tiles"))
      @race = race
      @output_path = Pathname(output_path)
      @zoom = zoom
      @grid_size = grid_size
      @cache_dir = Pathname(cache_dir)
      @tile_cache = {}
    end

    def call
      bounds = padded_bounds
      elevations = grid(bounds)
      min_ft, max_ft = elevations.minmax

      artifact = {
        "race" => { "slug" => @race.slug, "name" => @race.name, "year" => @race.year },
        "generated_at" => Time.now.utc.iso8601,
        "source" => {
          "label" => "AWS Terrain Tiles (Mapzen/Tilezen Terrarium DEM)",
          "url" => "https://registry.opendata.aws/terrain-tiles/",
          "attribution" => "Terrain tiles by Mapzen / Tilezen, from the AWS Open Data Terrain Tiles dataset.",
          "reference" => "Adapted for ultrainfo from the MIT kaolti/monolith-terrain DEM approach."
        },
        "grid" => {
          "size" => @grid_size,
          "zoom" => @zoom,
          "bounds" => bounds,
          "min_ft" => min_ft,
          "max_ft" => max_ft,
          "elevations_ft" => elevations
        },
        "projection" => {
          "type" => "linear-lat-lng-bounds",
          "note" => "Course, crew route, and station coordinates are projected into this bounded terrain plane in the browser."
        }
      }

      FileUtils.mkdir_p(@output_path.dirname)
      File.write(@output_path, JSON.pretty_generate(artifact))
      artifact
    end

    private

    def grid(bounds)
      Array.new(@grid_size * @grid_size) do |index|
        row = index / @grid_size
        col = index % @grid_size
        lat = bounds["max_lat"] - ((bounds["max_lat"] - bounds["min_lat"]) * row / (@grid_size - 1).to_f)
        lng = bounds["min_lng"] + ((bounds["max_lng"] - bounds["min_lng"]) * col / (@grid_size - 1).to_f)
        sample_elevation_ft(lat, lng).round
      end
    end

    def padded_bounds
      coords = @race.simplified_track.map { |lat, lng| [ lat.to_f, lng.to_f ] }
      coords += @race.aid_stations.filter_map { |station| [ station.lat.to_f, station.lng.to_f ] if station.coordinates? }
      coords += Array(@race.crew_route&.dig("geometry")).map { |lat, lng| [ lat.to_f, lng.to_f ] }

      lats = coords.map(&:first)
      lngs = coords.map(&:last)
      lat_pad = [ (lats.max - lats.min) * 0.08, 0.01 ].max
      lng_pad = [ (lngs.max - lngs.min) * 0.08, 0.01 ].max

      {
        "min_lat" => (lats.min - lat_pad).round(6),
        "max_lat" => (lats.max + lat_pad).round(6),
        "min_lng" => (lngs.min - lng_pad).round(6),
        "max_lng" => (lngs.max + lng_pad).round(6)
      }
    end

    def sample_elevation_ft(lat, lng)
      global_x, global_y = global_pixels(lat, lng)
      tile_x = (global_x / TILE_SIZE).floor
      tile_y = (global_y / TILE_SIZE).floor
      pixel_x = global_x.floor % TILE_SIZE
      pixel_y = global_y.floor % TILE_SIZE

      rgba = tile_rgba(tile_x, tile_y)
      offset = ((pixel_y * TILE_SIZE) + pixel_x) * 4
      meters = rgba[offset] * 256 + rgba[offset + 1] + (rgba[offset + 2] / 256.0) - 32768
      meters * FT_PER_M
    end

    def global_pixels(lat, lng)
      lat_rad = lat * Math::PI / 180
      world_size = TILE_SIZE * (2**@zoom)
      x = ((lng + 180) / 360.0) * world_size
      y = ((1 - Math.log(Math.tan(lat_rad) + (1 / Math.cos(lat_rad))) / Math::PI) / 2) * world_size
      [ x, y ]
    end

    def tile_rgba(tile_x, tile_y)
      wrapped_x = tile_x % (2**@zoom)
      key = [ @zoom, wrapped_x, tile_y ]
      @tile_cache[key] ||= decode_tile(fetch_tile(wrapped_x, tile_y))
    end

    def fetch_tile(tile_x, tile_y)
      path = @cache_dir.join(@zoom.to_s, tile_x.to_s, "#{tile_y}.png")
      return path if path.exist?

      FileUtils.mkdir_p(path.dirname)
      url = format(TILE_URL, z: @zoom, x: tile_x, y: tile_y)
      response = Net::HTTP.get_response(URI(url))
      raise "Terrain tile fetch failed #{url}: HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      File.binwrite(path, response.body)
      path
    end

    def decode_tile(path)
      stdout, stderr, status = Open3.capture3(magick_command, path.to_s, "rgba:-")
      raise "ImageMagick failed decoding #{path}: #{stderr}" unless status.success?

      stdout.bytes
    end

    def magick_command
      @magick_command ||= begin
        command = `which magick`.strip
        raise "ImageMagick `magick` is required to preprocess terrain tiles" if command.blank?

        command
      end
    end
  end
end

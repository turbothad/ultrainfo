require "net/http"
require "open3"

module Terrain
  # Acquires elevations from the external Mapzen/Tilezen Terrarium tile set.
  class TerrariumTiles
    TILE_SIZE = 256
    TILE_URL = "https://s3.amazonaws.com/elevation-tiles-prod/terrarium/%<z>d/%<x>d/%<y>d.png"
    FT_PER_M = 3.28084

    def initialize(cache_dir: Rails.root.join("tmp/terrain_tiles"))
      @cache_dir = Pathname(cache_dir)
      @tile_cache = {}
    end

    def elevation_ft(lat:, lng:, zoom:)
      global_x, global_y = global_pixels(lat, lng, zoom)
      tile_x = (global_x / TILE_SIZE).floor
      tile_y = (global_y / TILE_SIZE).floor
      pixel_x = global_x.floor % TILE_SIZE
      pixel_y = global_y.floor % TILE_SIZE

      rgba = tile_rgba(tile_x, tile_y, zoom)
      offset = ((pixel_y * TILE_SIZE) + pixel_x) * 4
      meters = rgba[offset] * 256 + rgba[offset + 1] + (rgba[offset + 2] / 256.0) - 32_768
      meters * FT_PER_M
    end

    private

    def global_pixels(lat, lng, zoom)
      lat_rad = lat * Math::PI / 180
      world_size = TILE_SIZE * (2**zoom)
      x = ((lng + 180) / 360.0) * world_size
      y = ((1 - Math.log(Math.tan(lat_rad) + (1 / Math.cos(lat_rad))) / Math::PI) / 2) * world_size
      [ x, y ]
    end

    def tile_rgba(tile_x, tile_y, zoom)
      wrapped_x = tile_x % (2**zoom)
      key = [ zoom, wrapped_x, tile_y ]
      @tile_cache[key] ||= decode_tile(fetch_tile(wrapped_x, tile_y, zoom))
    end

    def fetch_tile(tile_x, tile_y, zoom)
      path = @cache_dir.join(zoom.to_s, tile_x.to_s, "#{tile_y}.png")
      return path if path.exist?

      FileUtils.mkdir_p(path.dirname)
      url = format(TILE_URL, z: zoom, x: tile_x, y: tile_y)
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

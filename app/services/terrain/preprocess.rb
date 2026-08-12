module Terrain
  # Builds a static terrain artifact from public Mapzen/Tilezen Terrarium DEM tiles.
  # The browser renderer consumes the committed JSON artifact, so page load does
  # not depend on fetching elevation tiles.
  class Preprocess
    def initialize(race, output_path:, zoom: 11, grid_size: 96, tile_source: TerrariumTiles.new)
      @race = race
      @output_path = Pathname(output_path)
      @zoom = zoom
      @grid_size = grid_size
      @tile_source = tile_source
    end

    def call
      bounds = padded_bounds
      elevations = grid(bounds)
      min_ft, max_ft = elevations.minmax
      course_grade_profile = CourseGradeProfile.new(
        @race.simplified_track,
        elevation_at: method(:sample_elevation_ft)
      ).call

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
        "course_grade_profile" => course_grade_profile
      }

      Artifact.write(artifact, to: @output_path)
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
      @tile_source.elevation_ft(lat: lat, lng: lng, zoom: @zoom)
    end
  end
end

require "test_helper"

module Terrain
  class PreprocessTest < ActiveSupport::TestCase
    class FakePreprocess < Preprocess
      private

      def sample_elevation_ft(lat, lng)
        4_000 + ((lat + lng) * 10)
      end
    end

    test "writes a race-scoped terrain artifact" do
      race = Race.create!(
        name: "Bighorn 100", slug: "bighorn-100", year: 2026,
        simplified_track: [ [ 44.8, -107.3 ], [ 44.9, -107.4 ] ],
        crew_route: { "geometry" => [ [ 44.81, -107.31 ], [ 44.91, -107.41 ] ] }
      )
      race.aid_stations.create!(name: "Dry Fork", sequence: 1, lat: 44.85, lng: -107.35)
      output = Rails.root.join("tmp/terrain-test/bighorn-100.json")

      artifact = FakePreprocess.new(race, output_path: output, grid_size: 4).call

      assert File.exist?(output)
      assert_equal "bighorn-100", artifact.dig("race", "slug")
      assert_equal 4, artifact.dig("grid", "size")
      assert_equal 16, artifact.dig("grid", "elevations_ft").size
      assert_equal "linear-lat-lng-bounds", artifact.dig("projection", "type")
      assert_match "Terrain Tiles", artifact.dig("source", "label")
    ensure
      FileUtils.rm_f(output) if output
    end
  end
end

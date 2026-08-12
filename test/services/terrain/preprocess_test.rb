require "test_helper"

module Terrain
  class PreprocessTest < ActiveSupport::TestCase
    class FakeTileSource
      def elevation_ft(lat:, lng:, zoom:)
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

      artifact = Preprocess.new(
        race,
        output_path: output,
        grid_size: 4,
        tile_source: FakeTileSource.new
      ).call

      assert File.exist?(output)
      assert_instance_of Artifact, artifact
      assert_equal "bighorn-100", artifact.data.dig("race", "slug")
      assert_equal 4, artifact.data.dig("grid", "size")
      assert_equal 16, artifact.data.dig("grid", "elevations_ft").size
      assert_equal 1, artifact.data.dig("course_grade_profile", "segments").size
      assert_includes %w[flat moderate steep], artifact.data.dig("course_grade_profile", "segments", 0, "steepness")
      assert_equal Artifact::PROJECTION, artifact.data.fetch("projection")
      assert_match "Terrain Tiles", artifact.data.dig("source", "label")
      assert_equal Digest::SHA256.file(output).hexdigest, artifact.sha256
    ensure
      FileUtils.rm_f(output) if output
    end
  end
end

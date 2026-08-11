require "test_helper"

module Terrain
  class CourseGradeProfileTest < ActiveSupport::TestCase
    FEET_PER_DEGREE = 364_568.0

    test "classifies uphill and downhill segments by absolute grade" do
      points = points_at_1_000_foot_intervals(4)
      uphill = profile(points, [ 0, 40, 120, 260 ], window_ft: 10)
      downhill = profile(points, [ 260, 120, 40, 0 ], window_ft: 10)

      assert_equal %w[flat moderate steep], uphill.dig("segments").pluck("steepness")
      assert_equal %w[steep moderate flat], downhill.dig("segments").pluck("steepness")
      assert_in_delta 4.0, uphill.dig("segments", 0, "grade_pct"), 0.1
      assert_in_delta(-14.0, downhill.dig("segments", 0, "grade_pct"), 0.1)
    end

    test "smooths short elevation noise over the configured distance" do
      points = points_at_1_000_foot_intervals(3)
      result = profile(points, [ 0, 200, 0 ], window_ft: 4_000)

      assert_equal %w[flat flat], result.dig("segments").pluck("steepness")
      assert_equal [ 0.0, 0.0 ], result.dig("segments").pluck("grade_pct")
    end

    test "returns its classification metadata with no segments for a short route" do
      result = described_class.new([ [ 44.0, -107.0 ] ], elevation_at: ->(*) { 4_000 }).call

      assert_empty result["segments"]
      assert_equal 1_320, result["smoothing_window_ft"]
      assert_equal({ "flat_max" => 5.0, "moderate_max" => 10.0 }, result["thresholds_pct"])
    end

    private

    def described_class = CourseGradeProfile

    def points_at_1_000_foot_intervals(count)
      count.times.map { |index| [ 0.0, index * 1_000.0 / FEET_PER_DEGREE ] }
    end

    def profile(points, elevations, window_ft:)
      elevation_by_lng = points.zip(elevations).to_h { |(lat, lng), elevation| [ lng, elevation ] }
      described_class.new(
        points,
        elevation_at: ->(_lat, lng) { elevation_by_lng.fetch(lng) },
        window_ft: window_ft
      ).call
    end
  end
end

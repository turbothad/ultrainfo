module Terrain
  class CourseGradeProfile
    EARTH_RADIUS_FT = 20_902_231.0
    DEFAULT_WINDOW_FT = 1_320.0
    FLAT_MAX_PCT = 5.0
    MODERATE_MAX_PCT = 10.0

    def initialize(points, elevation_at:, window_ft: DEFAULT_WINDOW_FT)
      @points = points.map { |lat, lng| [ lat.to_f, lng.to_f ] }
      @elevation_at = elevation_at
      @window_ft = window_ft.to_f
    end

    def call
      return empty_profile if @points.size < 2

      samples = @points.map do |lat, lng|
        { coordinates: [ lat, lng ], elevation_ft: @elevation_at.call(lat, lng).to_f }
      end
      cumulative_distances = cumulative_distances_for(samples)

      {
        "smoothing_window_ft" => @window_ft.round,
        "thresholds_pct" => {
          "flat_max" => FLAT_MAX_PCT,
          "moderate_max" => MODERATE_MAX_PCT
        },
        "segments" => samples.each_cons(2).with_index.map do |(from, to), index|
          grade = smoothed_grade(index, samples, cumulative_distances)
          {
            "from" => from[:coordinates],
            "to" => to[:coordinates],
            "grade_pct" => grade.round(1),
            "steepness" => steepness(grade)
          }
        end
      }
    end

    private

    def empty_profile
      {
        "smoothing_window_ft" => @window_ft.round,
        "thresholds_pct" => {
          "flat_max" => FLAT_MAX_PCT,
          "moderate_max" => MODERATE_MAX_PCT
        },
        "segments" => []
      }
    end

    def cumulative_distances_for(samples)
      samples.each_cons(2).each_with_object([ 0.0 ]) do |(from, to), distances|
        distances << distances.last + horizontal_distance_ft(from[:coordinates], to[:coordinates])
      end
    end

    def smoothed_grade(index, samples, cumulative_distances)
      segment_start = cumulative_distances[index]
      segment_end = cumulative_distances[index + 1]
      return 0.0 if segment_end <= segment_start

      midpoint = (segment_start + segment_end) / 2.0
      half_window = @window_ft / 2.0
      from_distance = [ midpoint - half_window, 0.0 ].max
      to_distance = [ midpoint + half_window, cumulative_distances.last ].min
      run = to_distance - from_distance
      return 0.0 if run <= 0

      rise = elevation_at_distance(samples, cumulative_distances, to_distance) -
        elevation_at_distance(samples, cumulative_distances, from_distance)
      rise / run * 100.0
    end

    def elevation_at_distance(samples, cumulative_distances, distance)
      upper = cumulative_distances.bsearch_index { |value| value >= distance } || cumulative_distances.size - 1
      return samples.first[:elevation_ft] if upper.zero?

      lower = upper - 1
      span = cumulative_distances[upper] - cumulative_distances[lower]
      return samples[upper][:elevation_ft] if span <= 0

      fraction = (distance - cumulative_distances[lower]) / span
      samples[lower][:elevation_ft] +
        ((samples[upper][:elevation_ft] - samples[lower][:elevation_ft]) * fraction)
    end

    def horizontal_distance_ft(from, to)
      lat1, lng1 = from.map { |value| value * Math::PI / 180.0 }
      lat2, lng2 = to.map { |value| value * Math::PI / 180.0 }
      dlat = lat2 - lat1
      dlng = lng2 - lng1
      a = Math.sin(dlat / 2)**2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dlng / 2)**2
      a = a.clamp(0.0, 1.0)
      EARTH_RADIUS_FT * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    end

    def steepness(grade)
      absolute_grade = grade.abs
      return "flat" if absolute_grade < FLAT_MAX_PCT
      return "moderate" if absolute_grade <= MODERATE_MAX_PCT

      "steep"
    end
  end
end

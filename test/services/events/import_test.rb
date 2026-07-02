require "test_helper"

module Events
  class ImportTest < ActiveSupport::TestCase
    test "imports a race end-to-end from its db/events data files" do
      race = Import.new(Rails.root.join("db/events/bighorn-100.yml").to_s).call

      assert_equal "Bighorn 100", race.name
      assert_equal 20_500, race.elevation_gain_ft
      assert_equal Date.new(2026, 6, 19), race.start_date
      assert race.closed?
      assert_equal 600, race.simplified_track.size
      assert_equal 13, race.aid_stations.count
      assert race.aid_stations.all?(&:coordinates?), "every station gets coords from the GPX waypoints"
      assert_equal 4, race.crew_route["legs"].size, "cached crew route: 5 drivable trailheads = 4 legs"
    end
  end
end

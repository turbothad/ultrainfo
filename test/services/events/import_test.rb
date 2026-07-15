require "test_helper"

module Events
  class ImportTest < ActiveSupport::TestCase
    test "imports a race end-to-end from its db/events data files" do
      race = Import.new(Rails.root.join("db/events/bighorn-100.yml").to_s).call

      assert_equal "Bighorn 100", race.name
      assert_equal 20_500, race.elevation_gain_ft
      assert_equal Date.new(2026, 6, 19), race.start_date
      assert_equal Date.new(2026, 6, 20), race.end_date
      assert race.closed?
      assert_equal "America/Denver", race.time_zone
      assert_equal "https://bhtr.itsyourrace.com/Results.aspx?id=384", race.results_url
      assert_equal "verified", race.source_metadata["verification_status"]
      sources = race.source_metadata.fetch("sources").index_by { |source| source.fetch("label") }
      assert_equal "https://img1.wsimg.com/blobby/go/07161f14-d61e-453c-a3cc-f57e0150d044/Bighorn100_Course_Description-0cce83e.pdf",
                   sources.fetch("Official Course Description PDF").fetch("url")
      assert_equal "https://img1.wsimg.com/blobby/go/07161f14-d61e-453c-a3cc-f57e0150d044/downloads/30d8acf5-26bd-40cf-b6a4-a5ffefb537e2/Bighorn%20100%20Aid%20Station%20Chart.pdf?ver=1782760210683",
                   sources.fetch("Official Aid Station Chart PDF").fetch("url")
      assert_equal 600, race.simplified_track.size
      assert_equal 22, race.aid_stations.count
      assert race.aid_stations.all?(&:coordinates?), "every station gets coords from the GPX waypoints"
      assert_equal "30h", race.aid_stations.find_by!(mile: 82.5).cutoff_elapsed_label
      assert_equal 4, race.crew_route["legs"].size, "cached crew route: 5 drivable trailheads = 4 legs"
    end

    test "re-imports the event without duplicating the race" do
      path = Rails.root.join("db/events/bighorn-100.yml").to_s

      first = Import.new(path).call
      second = Import.new(path).call

      assert_equal 1, Race.where(slug: "bighorn-100").count
      assert_not_equal first.id, second.id
      assert_equal "https://bhtr.itsyourrace.com/Results.aspx?id=384", second.results_url
      assert_equal 22, second.aid_stations.count
    end
  end
end

require "test_helper"

class StationPassPresentationTest < ActiveSupport::TestCase
  setup { @race = Race.create!(name: "Bighorn 100", slug: "bighorn-100", year: 2026) }

  test "presents cutoff and landmark semantics from the station pass direction" do
    station = @race.aid_stations.create!(
      name: "Ordinary Name",
      direction: "Turnaround",
      cutoff: "legacy",
      cutoff_clock: "4:00 AM",
      cutoff_elapsed_minutes: 1_140
    )

    presentation = StationPassPresentation.call(station)

    assert_equal "Turnaround", presentation.fetch(:direction)
    assert_equal "Turnaround", presentation.fetch(:direction_label)
    assert_equal "legacy", presentation.fetch(:cutoff)
    assert_equal "4:00 AM / 19h", presentation.fetch(:cutoff_label)
    assert presentation.fetch(:landmark)
  end

  test "does not guess landmark semantics from the station pass name" do
    station = @race.aid_stations.create!(name: "Finish Ridge", direction: "Outbound")

    assert_not StationPassPresentation.call(station).fetch(:landmark)
  end

  test "presents legacy and missing cutoffs explicitly" do
    legacy = @race.aid_stations.create!(name: "Legacy", cutoff: "8:30 PM")
    missing = @race.aid_stations.create!(name: "Missing")

    assert_equal "8:30 PM", StationPassPresentation.call(legacy).fetch(:cutoff_label)
    assert_equal "None listed", StationPassPresentation.call(missing).fetch(:cutoff_label)
  end

  test "presents directions and verification without renderer-specific formatting" do
    station = @race.aid_stations.create!(
      name: "Dry Fork",
      lat: BigDecimal("44.850000"),
      lng: BigDecimal("-107.350000"),
      directions_notes: "Approach from the east.",
      source_metadata: {
        "verification_status" => "verified",
        "source_label" => "Aid Station Chart",
        "source_url" => "https://example.test/chart",
        "source_notes" => "Checked against the 2026 chart."
      }
    )

    presentation = StationPassPresentation.call(station)

    assert_equal({
      notes: "Approach from the east.",
      link_label: "Open map",
      url: "https://www.google.com/maps/dir/?api=1&destination=44.850000,-107.350000"
    }, presentation.fetch(:directions))
    assert_equal({
      status: "verified",
      label: "Verified source",
      verified_on: nil,
      source_label: "Aid Station Chart",
      source_url: "https://example.test/chart",
      source_notes: "Checked against the 2026 chart.",
      sources: []
    }, presentation.fetch(:verification))
  end

  test "maps station pass identity, feature labels, and road notes for every renderer" do
    station = @race.aid_stations.create!(
      name: "Dry Fork",
      sequence: 7,
      mile: 13.5,
      direction: "Outbound",
      elevation_ft: 7_480,
      crew_accessible: true,
      crew_access_notes: "Crew welcome.",
      drop_bag: true,
      pacer_access: false,
      has_medical: true,
      road_notes: "Use Highway 14 only."
    )

    presentation = StationPassPresentation.call(station)

    assert_equal station.id, presentation.fetch(:id)
    assert_equal "station_pass_aid_station_#{station.id}", presentation.fetch(:details_id)
    assert_equal "Dry Fork", presentation.fetch(:name)
    assert_equal 7, presentation.fetch(:sequence)
    assert_equal 13.5, presentation.fetch(:mile)
    assert_equal "7,480 ft", presentation.fetch(:elevation)
    assert_equal "Use Highway 14 only.", presentation.fetch(:road)
    assert_equal [
      { key: "crew", label: "Crew", available: true, value: "Allowed", detail_label: "Crew", detail: "Crew welcome.", filter: "crew" },
      { key: "drop_bag", label: "Drop bag", available: true, value: "Yes", detail_label: "Drop bag", detail: "Yes", filter: "drop" },
      { key: "pacer", label: "Pacer pickup", available: false, value: "No", detail_label: "Pacer pickup allowed", detail: "No", filter: "pacer" },
      { key: "medical", label: "Medical", available: true, value: "Yes", detail_label: "Medical", detail: "Yes", filter: nil }
    ], presentation.fetch(:features)
  end

  test "presents water provenance, verification date, and the next station pass" do
    station = @race.aid_stations.create!(
      name: "Lower Sheep Creek",
      sequence: 2,
      mile: 3.5,
      elevation_ft: 5_025,
      has_water: true,
      potable_water: nil,
      source_metadata: {
        "verification_status" => "verified",
        "verified_on" => "2026-08-13",
        "source_label" => "Bighorn 100 Aid Station Chart"
      }
    )
    next_station = @race.aid_stations.create!(
      name: "Upper Sheep Creek",
      sequence: 3,
      mile: 8.5,
      elevation_ft: 7_450
    )

    presentation = StationPassPresentation.call(station, next_station_pass: next_station)

    assert_equal "Yes", presentation.fetch(:water_label)
    assert_equal "Not specified", presentation.fetch(:potable_water_label)
    assert_equal "2026-08-13", presentation.dig(:verification, :verified_on)
    assert_equal({
      name: "Upper Sheep Creek",
      distance: "5 mi",
      elevation: "7,450 ft",
      elevation_change: "Up 2,425 ft net",
      label: "5 mi by markers · next marker 7,450 ft · Up 2,425 ft net between markers"
    }, presentation.fetch(:next_station_pass))
  end

  test "does not claim water or next-station facts that the Race record does not specify" do
    station = @race.aid_stations.create!(name: "Dry Fork", has_water: nil)

    presentation = StationPassPresentation.call(station)

    assert_equal "Not specified", presentation.fetch(:water_label)
    assert_equal "Not specified", presentation.fetch(:features).find { |feature| feature[:key] == "drop_bag" }.fetch(:value)
    assert_equal "Not specified", presentation.fetch(:features).find { |feature| feature[:key] == "medical" }.fetch(:value)
    assert_nil presentation.fetch(:next_station_pass)
  end
end

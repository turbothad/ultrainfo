require "test_helper"

class AidStationTest < ActiveSupport::TestCase
  setup { @race = Race.create!(name: "A", slug: "a-100", year: 2026) }

  test "requires a name and a race" do
    assert_not AidStation.new.valid?
    assert_not AidStation.new(race: @race).valid?, "name required"
    assert AidStation.new(race: @race, name: "Dry Fork").valid?
  end

  test "crew scope returns only crew-accessible stations" do
    @race.aid_stations.create!(name: "Crew", sequence: 1, crew_accessible: true)
    @race.aid_stations.create!(name: "None", sequence: 2, crew_accessible: false)
    assert_equal [ "Crew" ], @race.aid_stations.crew.map(&:name)
  end

  test "coordinates? is true only with both lat and lng" do
    assert_not AidStation.new(race: @race, name: "X").coordinates?
    assert_not AidStation.new(race: @race, name: "X", lat: 1).coordinates?
    assert AidStation.new(race: @race, name: "X", lat: 1, lng: 2).coordinates?
  end

  test "turnaround? identifies the turnaround pass" do
    assert AidStation.new(direction: "Turnaround").turnaround?
    assert_not AidStation.new(direction: "Outbound").turnaround?
  end

  test "cutoff elapsed label formats hours and minutes" do
    assert_equal "6h", AidStation.new(cutoff_elapsed_minutes: 360).cutoff_elapsed_label
    assert_equal "33h 45m", AidStation.new(cutoff_elapsed_minutes: 2025).cutoff_elapsed_label
    assert_nil AidStation.new.cutoff_elapsed_label
  end

  test "cutoff display can fall back to legacy cutoff text" do
    helper = Class.new { include ApplicationHelper }.new

    assert_equal "8:30 PM", helper.cutoff_display(AidStation.new(cutoff: "8:30 PM"))
    assert_equal "8:30 PM / 11h 30m", helper.cutoff_display(
      AidStation.new(cutoff: "legacy", cutoff_clock: "8:30 PM", cutoff_elapsed_minutes: 690)
    )
    assert_equal "None listed", helper.cutoff_display(AidStation.new)
  end

  test "directions destination formats decimal columns as standard coordinates" do
    helper = Class.new { include ApplicationHelper }.new
    station = AidStation.new(lat: BigDecimal("44.850000"), lng: BigDecimal("-107.350000"))

    assert_equal "44.850000,-107.350000", helper.directions_destination(station)
  end
end

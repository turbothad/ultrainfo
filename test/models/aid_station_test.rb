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
end

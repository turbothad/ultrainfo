require "test_helper"

class RacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @race = Race.create!(
      name: "Bighorn 100", slug: "bighorn-100", year: 2026, state: "WY",
      distance_mi: 100.4, start_lat: 44.87, start_lng: -107.26,
      simplified_track: [ [ 44.87, -107.26 ], [ 44.66, -107.50 ] ]
    )
    @crew = @race.aid_stations.create!(name: "Dry Fork", sequence: 1, mile: 13.4, crew_accessible: true, lat: 44.8, lng: -107.3)
    @nocrew = @race.aid_stations.create!(name: "Cow Camp", sequence: 2, mile: 19.6, crew_accessible: false)
  end

  test "overview renders the race" do
    get race_path(@race)
    assert_response :success
    assert_select "h1", /Bighorn 100/i
  end

  test "runner page lists every aid station" do
    get runner_race_path(@race)
    assert_response :success
    assert_select "td", /Dry Fork/
    assert_select "td", /Cow Camp/
  end

  test "crew page shows only crew-accessible stations" do
    get crew_race_path(@race)
    assert_response :success
    assert_select "td", /Dry Fork/
    assert_select "td", { text: /Cow Camp/, count: 0 }
  end

  test "follow page renders" do
    get follow_race_path(@race)
    assert_response :success
  end

  test "map endpoint returns course + stations as JSON" do
    get map_race_path(@race, format: :json)
    assert_response :success
    data = JSON.parse(@response.body)
    assert_equal 2, data["course"].length
    assert_equal 2, data["stations"].length
    assert data["stations"].find { |s| s["name"] == "Dry Fork" }["crew"]
  end

  test "unknown slug returns 404" do
    get race_path("nope")
    assert_response :not_found
  end
end

require "test_helper"

class RacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @race = Race.create!(
      name: "Bighorn 100", slug: "bighorn-100", year: 2026, state: "WY",
      distance_mi: 100.4, start_lat: 44.87, start_lng: -107.26,
      simplified_track: [ [ 44.87, -107.26 ], [ 44.66, -107.50 ] ]
    )
    @crew = @race.aid_stations.create!(name: "Dry Fork", sequence: 1, mile: 13.4, crew_accessible: true, lat: 44.8, lng: -107.3, cutoff_elapsed_minutes: 360)
    @nocrew = @race.aid_stations.create!(name: "Cow Camp", sequence: 2, mile: 19.6, crew_accessible: false)
  end

  test "race page renders one scrolling surface organized by information type" do
    get race_path(@race)

    assert_response :success
    assert_select "h1", /Bighorn 100/i
    assert_select "main > header", 1
    assert_select "main section", 6
    section_ids = css_select("main section[id]").map { |section| section["id"] }
    assert_equal %w[facts course aid-stations crew follow sources], section_ids
    assert_select "#facts", /first race in the USA ultra source-of-truth database/
    assert_select "nav[aria-label='On this race page']" do
      %w[facts course aid-stations crew follow sources].each do |section_id|
        assert_select "a[href='##{section_id}']", 1
      end
    end
    assert_select "[data-controller='terrain-map']", 1
    assert_select "#aid-stations table", 1
    assert_select "#aid-stations tbody tr", @race.aid_stations.count
    assert_select "[role='tablist']", 0
  end

  test "legacy role and HTML map routes permanently redirect to canonical sections" do
    {
      runner_race_path(@race) => "aid-stations",
      crew_race_path(@race) => "crew",
      follow_race_path(@race) => "follow",
      map_race_path(@race) => "course"
    }.each do |legacy_path, section_id|
      get legacy_path

      assert_response :moved_permanently
      assert_equal race_url(@race, anchor: section_id), @response.location
    end
  end

  test "map endpoint returns course, stations, and crew route as JSON" do
    @race.update!(
      crew_route: { "geometry" => [ [ 44.8, -107.3 ], [ 44.7, -107.4 ] ], "distance_mi" => 12.3, "duration_min" => 25 },
      terrain_artifacts: { "path" => "/terrain/missing-test.json", "generated_on" => "2026-07-08" }
    )
    get map_race_path(@race, format: :json)
    assert_response :success
    data = JSON.parse(@response.body)
    assert_equal 2, data["course"].length
    assert_equal 2, data["stations"].length
    assert data["stations"].find { |s| s["name"] == "Dry Fork" }["crew"]
    assert_equal "6h", data["stations"].find { |s| s["name"] == "Dry Fork" }["cutoff_elapsed_label"]
    assert_equal 12.3, data["crew_route"]["distance_mi"]
    assert_equal "/terrain/missing-test.json?v=2026-07-08", data["terrain_artifacts"]["path"]
  end

  test "unknown slug returns 404" do
    get race_path("nope")
    assert_response :not_found
  end
end

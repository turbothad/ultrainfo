require "test_helper"

class RacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @race = Race.create!(
      name: "Bighorn 100", slug: "bighorn-100", year: 2026, state: "WY",
      distance_mi: 100.4, start_lat: 44.87, start_lng: -107.26,
      start_time: "9:00 AM", cutoff_hours: 35,
      simplified_track: [ [ 44.87, -107.26 ], [ 44.66, -107.50 ] ]
    )
    @crew = @race.aid_stations.create!(
      name: "Dry Fork", sequence: 1, direction: "Turnaround", mile: 13.4,
      crew_accessible: true, lat: 44.8, lng: -107.3,
      cutoff_clock: "4:00 AM", cutoff_elapsed_minutes: 360,
      directions_notes: "Approach from the east.", road_notes: "Use Highway 14 only.",
      source_metadata: { "verification_status" => "verified", "source_label" => "Aid Station Chart" }
    )
    @nocrew = @race.aid_stations.create!(name: "Cow Camp", sequence: 2, mile: 19.6, crew_accessible: false)
  end

  test "race page is one source-of-truth scroll" do
    @race.update!(
      registration_url: "https://example.test/register",
      registration_status: :waitlist,
      lottery: true,
      results_url: "https://example.test/results",
      crew_route: { "distance_mi" => 12.3, "duration_min" => 25, "geometry" => [] },
      source_metadata: {
        "verification_status" => "verified",
        "overall_cutoff_notes" => "Official sources disagree.",
        "section_verifications" => { "race_facts" => { "verified_on" => "2026-08-13" } },
        "sources" => [ { "label" => "Race guide", "url" => "https://example.test/guide" } ]
      }
    )

    get race_path(@race)

    assert_response :success
    assert_select "h1", /Bighorn 100/i
    assert_equal %w[facts course aid-stations crew follow sources], css_select("main section[id]").map { |section| section["id"] }
    assert_select "[data-controller='terrain-map']", count: 1
    assert_select "button[data-action='terrain-map#resetView']", /reset view/i
    assert_select "button[data-action='terrain-map#topView']", /top view/i
    assert_select "[data-course-grade-legend]", /Flat.*Moderate.*Steep/im
    assert_select "button[data-terrain-map-target='stationPassButton']", count: 2
    assert_select "[data-terrain-map-target='detail']", /Select a station pass/i
    assert_select "button[data-action='station-filter#filter']", count: 4
    assert_select "table", count: 1
    assert_select "th", count: 6
    assert_select "th", /Aid & water/i
    assert_select "th", /Crew & bags/i
    assert_select "th", /Next marker/i
    assert_select "th", /Timing/i
    assert_select "details#station-pass-1"
    assert_select "details#station-pass-2"
    assert_select "a[href='https://example.test/register']", /registration/i
    assert_select "#facts", /Waitlist/i
    assert_select "#facts", /Lottery.*Yes/im
    assert_select "#facts", /35h.*disputed/im
    assert_select "#facts", /Cutoff source conflict.*Official sources disagree/im
    assert_select "[data-terrain-map-target='detail']", /35 h.*disputed/im
    assert_select "#facts", /Last checked/i
    assert_select "a[href='https://example.test/results']", /results/i
    assert_select "#follow", /4:00 AM \/ 6h/
    assert_select "#station-pass-1", /Drop bag/i
    assert_select "#station-pass-1", /Crew allowed/i
    assert_select "#station-pass-1", /Medical/i
    assert_select "a[data-action='race-page#showCrewDrive']", /crew drive/i
    assert_select "#sources details", count: 0
    assert_select "#sources a[href='https://example.test/guide']", /Race guide/i
  end

  test "legacy role pages permanently redirect to canonical sections" do
    get runner_race_path(@race)
    assert_redirected_to race_path(@race, anchor: "aid-stations")
    assert_response :moved_permanently

    get crew_race_path(@race)
    assert_redirected_to race_path(@race, anchor: "crew")
    assert_response :moved_permanently

    get follow_race_path(@race)
    assert_redirected_to race_path(@race, anchor: "follow")
    assert_response :moved_permanently

    get map_race_path(@race)
    assert_redirected_to race_path(@race, anchor: "course")
    assert_response :moved_permanently
  end

  test "map endpoint returns course, stations, and crew route as JSON" do
    sha256 = "a" * 64
    @race.update!(
      crew_route: { "geometry" => [ [ 44.8, -107.3 ], [ 44.7, -107.4 ] ], "distance_mi" => 12.3, "duration_min" => 25 },
      terrain_artifacts: {
        "status" => "generated",
        "path" => "/terrain/missing-test.json",
        "schema_version" => Terrain::Artifact::SCHEMA_VERSION,
        "sha256" => sha256,
        "projection" => Terrain::Artifact::PROJECTION.fetch("type")
      }
    )
    get map_race_path(@race, format: :json)
    assert_response :success
    data = JSON.parse(@response.body)
    assert_equal 2, data["course"].length
    assert_equal 2, data["stations"].length
    station = data["stations"].find { |candidate| candidate["name"] == "Dry Fork" }
    assert_nil station["cutoff"]
    assert_equal "4:00 AM", station["cutoff_clock"]
    assert_equal 360, station["cutoff_elapsed_minutes"]
    assert_equal "6h", station["cutoff_elapsed_label"]
    assert_equal "4:00 AM / 6h", station["cutoff_label"]
    assert_equal "Use Highway 14 only.", station["road"]
    assert_equal "Use Highway 14 only.", station["road_notes"]
    assert station["crew"]
    assert_nil station["drop_bag"]
    assert_not station["pacer_pickup"]
    assert_not station.key?("pacer")
    assert_equal @crew.source_metadata, station["source_metadata"]
    assert station["landmark"]
    assert_equal "Approach from the east.", station.dig("directions", "notes")
    assert_equal "Verified source", station.dig("verification", "label")
    assert station["features"].find { |feature| feature["key"] == "crew" }["available"]
    assert_equal 12.3, data["crew_route"]["distance_mi"]
    assert_equal "/terrain/missing-test.json?v=#{sha256}", data["terrain_artifacts"]["path"]
  end


  test "Terrain accessibility label names the Race" do
    @race.update!(name: "Cloud Peak 100")

    get race_path(@race)

    assert_select "[data-terrain-map-target='canvas'][aria-label*='Cloud Peak 100']"
  end

  test "unknown slug returns 404" do
    get race_path("nope")
    assert_response :not_found
  end
end

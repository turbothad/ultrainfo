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

  test "race facts stay lean and connect registration and trust to official sources" do
    @race.update!(
      registration_status: :closed,
      registration_url: "https://registration.example.test/bighorn",
      source_metadata: {
        "verified_on" => "2026-07-01",
        "sources" => [
          { "label" => "Course guide", "verified_on" => "2026-07-03" },
          { "label" => "Registration", "verified_on" => "2026-07-02" }
        ]
      }
    )

    get race_path(@race)

    assert_response :success
    assert_select "#facts" do
      assert_select "a[href='https://registration.example.test/bighorn']", text: "Official registration", count: 1
      assert_select "p", text: /All facts from official race materials · verified July 3, 2026 · Sources/
      assert_select "a[href='#sources']", text: "Sources", count: 1
      assert_select "h2", count: 0
    end
    assert_includes @response.body, "Closed"
    assert_not_includes @response.body, "Race facts without the scavenger hunt."
    assert_not_includes @response.body, "Launch scope"
  end

  test "station table renders progressive filter controls with every pass visible by default" do
    @crew.update!(drop_bag: true, pacer_access: true)

    get race_path(@race)

    assert_response :success
    assert_select "#aid-stations [data-controller='station-filter']" do
      assert_select "button", text: "All", count: 1
      assert_select "button", text: "Crew access", count: 1
      assert_select "button", text: "Drop bags", count: 1
      assert_select "button", text: "Pacer points", count: 1
      assert_select "tbody tr[data-station-filter-target='row']", count: 2
      assert_select "tbody tr[data-filter-tags~='crew'][data-filter-tags~='drop'][data-filter-tags~='pacer']", count: 1
      assert_select "tbody tr[hidden]", count: 0
    end
  end

  test "station table keeps medical, cutoffs, and complete sourced details in one canonical row" do
    @crew.update!(
      cutoff_clock: "3:00 PM", cutoff_elapsed_minutes: 360, elevation_ft: 7_480,
      has_medical: true, aid_notes: "Full aid", bathroom_notes: "Restrooms available",
      crew_access_notes: "Crew allowed", pacer_notes: "No pacers",
      parking_notes: "Park one-quarter mile away", road_notes: "Use Highway 14",
      directions_notes: "Follow signed access road",
      source_metadata: {
        "verification_status" => "warning", "source_label" => "Official course guide",
        "source_url" => "https://example.test/course-guide", "source_notes" => "Access note needs confirmation"
      }
    )
    @nocrew.update!(
      cutoff: "Wave-dependent cutoff", lat: 44.7, lng: -107.4,
      source_metadata: { "verification_status" => "unverified", "source_url" => "https://example.test/aid-chart" }
    )

    get race_path(@race)

    assert_response :success
    assert_select "#aid-stations th", text: "Medical", count: 1
    assert_select "#aid-stations tbody span[title='Yes']", text: "Yes", minimum: 1
    assert_select "#aid-stations tbody span[title='No']", text: "No", minimum: 1
    assert_includes @response.body, "3:00 PM / 6h"
    assert_includes @response.body, "Wave-dependent cutoff"

    details = css_select("#aid-stations details").find { |node| node.at_css("summary")&.text&.strip == "Dry Fork" }
    assert details, "expected expandable details for Dry Fork"
    detail_text = details.text.squish
    [
      "Elevation: 7,480 ft", "Aid: Full aid", "Medical: Yes", "Bathrooms: Restrooms available",
      "Crew: Crew allowed", "Pacer: No pacers", "Parking: Park one-quarter mile away",
      "Road: Use Highway 14", "Directions: Follow signed access road", "Verification: Source warning",
      "Source: Official course guide", "Source notes: Access note needs confirmation"
    ].each { |content| assert_includes detail_text, content }
    assert details.at_css("a[href='https://example.test/course-guide']"), "expected linked source identity"

    irregular_details = css_select("#aid-stations details").find { |node| node.at_css("summary")&.text&.strip == "Cow Camp" }
    assert_not_includes irregular_details.text.squish, "Directions: Not listed"
    assert irregular_details.at_css("a[href*='destination=44.700000,-107.400000']"), "expected coordinate directions link"
    assert_includes irregular_details.text.squish, "Source: https://example.test/aid-chart"
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

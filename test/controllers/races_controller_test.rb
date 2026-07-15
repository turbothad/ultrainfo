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

  test "sources section lists every race source as a citation without a drawer" do
    @race.update!(
      source_metadata: {
        "verification_status" => "warning",
        "sources" => [
          {
            "label" => "Official race page", "url" => "https://example.test/race",
            "verified_on" => "2026-07-02", "notes" => "Race facts and schedule."
          },
          {
            "label" => "Official aid chart", "url" => "https://example.test/aid-chart",
            "verified_on" => "2026-07-03", "notes" => "Station passes and cutoffs."
          }
        ],
        "notes" => "Official materials represented in the race record."
      }
    )

    get race_path(@race)

    assert_response :success
    assert_select "#facts", text: /Source warning/
    assert_select "#sources" do
      assert_select "ol[aria-label='Official source documents'] > li", count: 2
      assert_select "a[href='https://example.test/race']", text: "Official race page", count: 1
      assert_select "a[href='https://example.test/aid-chart']", text: "Official aid chart", count: 1
      assert_select "time[datetime='2026-07-02']", text: "Verified July 2, 2026", count: 1
      assert_select "time[datetime='2026-07-03']", text: "Verified July 3, 2026", count: 1
      assert_select "li", text: /Race facts and schedule\./, count: 1
      assert_select "li", text: /Station passes and cutoffs\./, count: 1
      assert_select "p", text: "Official materials represented in the race record.", count: 1
      assert_select "details, summary", count: 0
    end
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

  test "follow section shows key local clock times, tracking availability, and official results" do
    @race.update!(
      start_date: Date.new(2026, 6, 19), start_time: "9:00 AM", cutoff_hours: 35,
      time_zone: "America/Denver", results_url: "https://results.example.test/bighorn",
      finish_venue: "Scott Park"
    )
    @race.aid_stations.create!(
      name: "Jaws Trailhead", sequence: 3, mile: 48, direction: "Turnaround",
      cutoff_clock: "4:00 AM"
    )

    get race_path(@race)

    assert_response :success
    assert_select "#follow [aria-label='Key race times']" do
      assert_select "div", text: /Start\s+Fri · 9:00 AM MDT/
      assert_select "div", text: /Turnaround cutoff\s+Sat · 4:00 AM MDT/
      assert_select "div", text: /Final cutoff\s+Sat · 8:00 PM MDT/
    end
    assert_select "#follow", text: /official live tracking is not announced in the current source data/i
    assert_select "#follow a[href='https://results.example.test/bighorn']", text: "Official results", count: 1
    assert_select "#follow [aria-label='Finish']", text: /Scott Park/
  end

  test "follow section links official tracking when announced" do
    @race.update!(tracking_url: "https://tracking.example.test/bighorn")

    get race_path(@race)

    assert_response :success
    assert_select "#follow a[href='https://tracking.example.test/bighorn']", text: "Open official tracking", count: 1
    assert_select "#follow [aria-label='Live tracking']", text: /has not been announced/i, count: 0
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

  test "map stations identify the exact canonical station pass row" do
    return_pass = @race.aid_stations.create!(
      name: "Dry Fork", sequence: 3, mile: 82.5, direction: "Inbound",
      lat: @crew.lat, lng: @crew.lng
    )

    get map_race_path(@race, format: :json)

    assert_response :success
    stations = JSON.parse(@response.body).fetch("stations")
    outbound = stations.find { |station| station["id"] == @crew.id }
    inbound = stations.find { |station| station["id"] == return_pass.id }
    assert_equal "station_pass_aid_station_#{@crew.id}", outbound["details_id"]
    assert_equal "station_pass_aid_station_#{return_pass.id}", inbound["details_id"]
    assert_not_equal outbound["details_id"], inbound["details_id"]

    get race_path(@race)

    assert_response :success
    assert_select "#station_pass_aid_station_#{@crew.id} details", count: 1
    assert_select "#station_pass_aid_station_#{return_pass.id} details", count: 1
  end

  test "unknown slug returns 404" do
    get race_path("nope")
    assert_response :not_found
  end
end

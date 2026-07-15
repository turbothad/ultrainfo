require "application_system_test_case"

class RaceMapStationPassesTest < ApplicationSystemTestCase
  setup do
    @race = Race.create!(
      name: "Bighorn 100", slug: "bighorn-100", year: 2026, state: "WY",
      distance_mi: 100.4, start_lat: 44.87, start_lng: -107.26,
      simplified_track: [ [ 44.87, -107.26 ], [ 44.80, -107.30 ] ],
      terrain_artifacts: { "path" => "/terrain/bighorn-100.json" }
    )
    @outbound = @race.aid_stations.create!(
      name: "Dry Fork", sequence: 1, mile: 13.4, direction: "Outbound",
      crew_accessible: true, lat: 44.8, lng: -107.3
    )
    @inbound = @race.aid_stations.create!(
      name: "Dry Fork", sequence: 2, mile: 82.5, direction: "Inbound",
      cutoff_clock: "10:00 PM", crew_accessible: false, lat: 44.8, lng: -107.3
    )
  end

  test "marker quick facts open the matching station pass row" do
    visit race_path(@race)
    assert_selector "[data-terrain-map-target='status']", text: /DEM/

    click_station_marker(@inbound)

    within "[data-terrain-map-target='detail']" do
      assert_text "Dry Fork"
      assert_text /Mile 82.5/i
      assert_text "10:00 PM"
      assert_text /Crew\s+No/i
      assert_no_text /Pacer|Drop bag|Medical|Elevation|Source|Directions/i
      click_link "Full details"
    end

    assert_equal "#station_pass_aid_station_#{@inbound.id}", page.evaluate_script("window.location.hash")
    assert_selector "#station_pass_aid_station_#{@inbound.id} details[open]"
    assert_no_selector "#station_pass_aid_station_#{@outbound.id} details[open]"
  end

  test "terrain failure leaves useful course navigation in the map" do
    @race.update!(terrain_artifacts: { "path" => "/terrain/not-found.json" })

    visit race_path(@race)

    assert_selector "[data-terrain-map-target='status']", text: /terrain unavailable/i
    within "[data-terrain-map-target='fallback']" do
      assert_text "Terrain preview unavailable"
      assert_text "The elevation profile and station table remain available below."
      assert_link "Browse station passes", href: "#aid-stations"
    end
  end

  private

  def click_station_marker(station)
    page.execute_script <<~JAVASCRIPT
      const element = document.querySelector("[data-controller~='terrain-map']")
      const controller = window.Stimulus.getControllerForElementAndIdentifier(element, "terrain-map")
      // Canvas markers have no DOM node to click, so project the marker center into viewport coordinates.
      const marker = controller.stationMeshes.find((candidate) => candidate.userData.station.id === #{station.id})
      const point = marker.position.clone().project(controller.camera)
      const rect = controller.renderer.domElement.getBoundingClientRect()
      controller.renderer.domElement.dispatchEvent(new PointerEvent("pointerdown", {
        bubbles: true,
        clientX: rect.left + (point.x + 1) * rect.width / 2,
        clientY: rect.top + (1 - point.y) * rect.height / 2
      }))
    JAVASCRIPT
  end
end

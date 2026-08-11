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
      assert_text /Pacer\s+No/i
      assert_text /Drop bag\s+No/i
      assert_text /Medical\s+No/i
      assert_text /Elevation\s+Not listed/i
      assert_text /Source unverified/i
      assert_link "Directions"
      click_link "Full station pass"
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
    assert_no_selector "[data-course-grade-legend]", visible: true
    assert_no_match(/grade/i, find("[data-terrain-map-target='canvas']")["aria-label"])
  end

  test "terrain canvas contains varied rendered pixels" do
    visit race_path(@race)
    assert_selector "[data-terrain-map-target='status']", text: /DEM/

    pixel_stats = page.evaluate_script <<~JAVASCRIPT
      (() => {
        const element = document.querySelector("[data-controller~='terrain-map']")
        const controller = window.Stimulus.getControllerForElementAndIdentifier(element, "terrain-map")
        controller.renderer.render(controller.scene, controller.camera)
        const gl = controller.renderer.getContext()
        const width = gl.drawingBufferWidth
        const height = gl.drawingBufferHeight
        const pixels = new Uint8Array(width * height * 4)
        gl.readPixels(0, 0, width, height, gl.RGBA, gl.UNSIGNED_BYTE, pixels)

        const colors = new Set()
        // Quantized sampling ignores antialiasing noise while still distinguishing terrain from a flat clear color.
        const stride = Math.max(1, Math.floor(width * height / 2_000))
        for (let pixel = 0; pixel < width * height; pixel += stride) {
          const offset = pixel * 4
          colors.add(`${pixels[offset] >> 4},${pixels[offset + 1] >> 4},${pixels[offset + 2] >> 4}`)
        }
        return { width, height, sampledColors: colors.size }
      })()
    JAVASCRIPT

    assert_operator pixel_stats.fetch("width"), :>, 0
    assert_operator pixel_stats.fetch("height"), :>, 0
    assert_operator pixel_stats.fetch("sampledColors"), :>, 8
  end

  test "course grade bands use color and line thickness cues" do
    visit race_path(@race)
    assert_selector "[data-terrain-map-target='status']", text: /DEM/

    within "[data-course-grade-legend]" do
      assert_text "¼ MI AVG"
      assert_text /FLAT <5% · THIN LINE/i
      assert_text /MODERATE 5–10% · MEDIUM LINE/i
      assert_text /STEEP >10% · THICK LINE/i
    end
    assert_match(/color and line thickness indicate grade/i, find("[data-terrain-map-target='canvas']")["aria-label"])

    styles = page.evaluate_script <<~JAVASCRIPT
      (() => {
        const element = document.querySelector("[data-controller~='terrain-map']")
        const controller = window.Stimulus.getControllerForElementAndIdentifier(element, "terrain-map")
        return controller.layers.course.children.map((run) => ({
          steepness: run.userData.steepness,
          color: `#${run.material.color.getHexString()}`,
          radius: run.geometry.parameters.radius
        }))
      })()
    JAVASCRIPT

    styles_by_grade = styles.index_by { |style| style.fetch("steepness") }
    assert_equal({ "color" => "#6fcf86", "radius" => 0.14 }, styles_by_grade.fetch("flat").slice("color", "radius"))
    assert_equal({ "color" => "#f2c14e", "radius" => 0.2 }, styles_by_grade.fetch("moderate").slice("color", "radius"))
    assert_equal({ "color" => "#ef6351", "radius" => 0.26 }, styles_by_grade.fetch("steep").slice("color", "radius"))
  end

  test "crew route action enables the crew layer on the canonical map" do
    @race.update!(
      crew_route: {
        "geometry" => [ [ 44.8, -107.3 ], [ 44.75, -107.35 ] ],
        "distance_mi" => 12.3,
        "duration_min" => 25
      }
    )

    visit race_path(@race)
    assert_selector "[data-terrain-map-target='status']", text: /DEM/

    uncheck "Crew drive"
    assert_no_checked_field "Crew drive"
    assert_equal false, terrain_layer_visible("drive")

    within "#crew" do
      click_link "Show crew drive on map"
    end

    assert_equal "#course", page.evaluate_script("window.location.hash")
    assert_checked_field "Crew drive"
    assert_equal true, terrain_layer_visible("drive")
  end

  test "crew passes action filters the canonical station table" do
    visit race_path(@race)

    within "#crew" do
      click_link "Crew-accessible passes"
    end

    assert_equal "#aid-stations", page.evaluate_script("window.location.hash")
    within "#aid-stations" do
      assert_selector "button[aria-pressed='true']", text: /Crew access/i
      assert_text /Showing 1 station pass/i
      assert_selector "#station_pass_aid_station_#{@outbound.id}:not([hidden])"
      assert_selector "#station_pass_aid_station_#{@inbound.id}[hidden]", visible: :all
    end
  end

  test "jump navigation stacks against the site header and leaves section headings visible" do
    visit race_path(@race)
    page.execute_script("document.documentElement.style.scrollBehavior = 'auto'")

    within "nav[aria-label='On this race page']" do
      click_link "Aid & cutoffs"
    end
    page.execute_script("document.querySelector('#aid-stations').scrollIntoView()")

    geometry = page.evaluate_script <<~JAVASCRIPT
      (() => {
        const siteHeader = document.querySelector("body > header").getBoundingClientRect()
        const jumpNav = document.querySelector("nav[aria-label='On this race page']").getBoundingClientRect()
        const section = document.querySelector("#aid-stations").getBoundingClientRect()
        return { siteHeaderBottom: siteHeader.bottom, jumpNavTop: jumpNav.top,
                 jumpNavBottom: jumpNav.bottom, sectionTop: section.top }
      })()
    JAVASCRIPT

    assert_in_delta geometry.fetch("siteHeaderBottom"), geometry.fetch("jumpNavTop"), 1
    assert_operator geometry.fetch("sectionTop"), :>=, geometry.fetch("jumpNavBottom")
  end

  private

  def terrain_layer_visible(layer)
    page.evaluate_script <<~JAVASCRIPT
      (() => {
        const element = document.querySelector("[data-controller~='terrain-map']")
        return window.Stimulus.getControllerForElementAndIdentifier(element, "terrain-map").layers["#{layer}"].visible
      })()
    JAVASCRIPT
  end

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

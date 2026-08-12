require "application_system_test_case"

class RaceMapStationPassesTest < ApplicationSystemTestCase
  setup do
    @terrain_reference = YAML.load_file(
      Rails.root.join("db/events/bighorn-100.yml"),
      permitted_classes: [ Date ],
      aliases: true
    ).dig("race", "terrain_artifacts")
    @race = Race.create!(
      name: "Bighorn 100", slug: "bighorn-100", year: 2026, state: "WY",
      distance_mi: 100.4, start_lat: 44.87, start_lng: -107.26,
      simplified_track: [ [ 44.87, -107.26 ], [ 44.80, -107.30 ] ],
      terrain_artifacts: @terrain_reference
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
    @race.update!(terrain_artifacts: @terrain_reference.merge("path" => "/terrain/not-found.json"))

    visit race_path(@race)

    assert_selector "[data-terrain-map-target='status']", text: /terrain unavailable/i
    within "[data-terrain-map-target='fallback']" do
      assert_text "Terrain preview unavailable"
      assert_text "The elevation profile and station table remain available below."
      assert_link "Browse station passes", href: "#aid-stations"
    end
  end

  test "stale Terrain metadata fails safely to useful course navigation" do
    @race.update!(terrain_artifacts: @terrain_reference.merge("sha256" => "0" * 64))

    visit race_path(@race)

    assert_selector "[data-terrain-map-target='status']", text: /SHA-256 digest does not match/i
    assert_selector "[data-terrain-map-target='fallback']:not([hidden])"
  end

  test "invalid Terrain projection fails safely to useful course navigation" do
    invalid_path = Rails.root.join("public/terrain/invalid-projection-test.json")
    invalid_artifact = JSON.parse(File.read(Rails.root.join("public/terrain/bighorn-100.json")))
    invalid_artifact.fetch("projection")["z_axis"] = "latitude-south-to-north"
    File.write(invalid_path, "#{JSON.pretty_generate(invalid_artifact)}\n")
    @race.update!(
      terrain_artifacts: @terrain_reference.merge(
        "path" => "/terrain/invalid-projection-test.json",
        "sha256" => Digest::SHA256.file(invalid_path).hexdigest
      )
    )

    visit race_path(@race)

    assert_selector "[data-terrain-map-target='status']", text: /projection is unsupported/i
    assert_selector "[data-terrain-map-target='fallback']:not([hidden])"
  ensure
    FileUtils.rm_f(invalid_path) if invalid_path
  end

  test "invalid course grade segments fail safely before rendering" do
    invalid_path = Rails.root.join("public/terrain/invalid-grade-test.json")
    invalid_artifact = JSON.parse(File.read(Rails.root.join("public/terrain/bighorn-100.json")))
    invalid_artifact.dig("course_grade_profile", "segments").first.delete("from")
    File.write(invalid_path, "#{JSON.pretty_generate(invalid_artifact)}\n")
    @race.update!(
      terrain_artifacts: @terrain_reference.merge(
        "path" => "/terrain/invalid-grade-test.json",
        "sha256" => Digest::SHA256.file(invalid_path).hexdigest
      )
    )

    visit race_path(@race)

    assert_selector "[data-terrain-map-target='status']", text: /segment coordinates are invalid/i
    assert_selector "[data-terrain-map-target='fallback']:not([hidden])"
  ensure
    FileUtils.rm_f(invalid_path) if invalid_path
  end

  test "blank Terrain metadata fails safely before rendering" do
    invalid_path = Rails.root.join("public/terrain/blank-metadata-test.json")
    invalid_artifact = JSON.parse(File.read(Rails.root.join("public/terrain/bighorn-100.json")))
    invalid_artifact.fetch("race")["name"] = "   "
    File.write(invalid_path, "#{JSON.pretty_generate(invalid_artifact)}\n")
    @race.update!(
      terrain_artifacts: @terrain_reference.merge(
        "path" => "/terrain/blank-metadata-test.json",
        "sha256" => Digest::SHA256.file(invalid_path).hexdigest
      )
    )

    visit race_path(@race)

    assert_selector "[data-terrain-map-target='status']", text: /Race name is missing/i
    assert_selector "[data-terrain-map-target='fallback']:not([hidden])"
  ensure
    FileUtils.rm_f(invalid_path) if invalid_path
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

    page.execute_script("document.documentElement.style.scrollBehavior = 'auto'")
    within "#crew" do
      click_link "Show crew drive on map"
    end

    assert_equal "#course", page.evaluate_script("window.location.hash")
    assert_checked_field "Crew drive"
  end

  test "crew passes action filters the canonical station table" do
    visit race_path(@race)

    page.execute_script("document.documentElement.style.scrollBehavior = 'auto'")
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

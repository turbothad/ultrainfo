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
      cutoff_clock: "10:00 PM", cutoff_elapsed_minutes: 2_220,
      crew_accessible: false, drop_bag: true, lat: 44.8, lng: -107.3,
      directions_notes: "Approach from Red Grade Road.",
      road_notes: "High-clearance vehicles recommended.",
      source_metadata: {
        "verification_status" => "verified",
        "source_label" => "Aid Station Chart",
        "source_url" => "https://example.test/chart"
      }
    )
  end

  test "station pass controls open the matching station pass row" do
    visit race_path(@race)
    assert_selector "[data-terrain-map-target='status']", text: /DEM/

    within "#course" do
      find("button", text: /Mile 82.5.*Inbound.*Dry Fork/im).click
      assert_selector "button[aria-pressed='true']", text: /Mile 82.5.*Inbound.*Dry Fork/im
    end

    within "[data-terrain-map-target='detail']" do
      assert_text "Dry Fork"
      assert_text /Mile 82.5/i
      assert_text "10:00 PM / 37h"
      assert_text /Crew\s+No/i
      assert_text /Pacer\s+No/i
      assert_text /Drop bag\s+Yes/i
      assert_text /Medical\s+No/i
      assert_text /Elevation\s+Not listed/i
      assert_text "Approach from Red Grade Road."
      assert_text "High-clearance vehicles recommended."
      assert_text /Verification\s+Verified source/i
      assert_link "Open map"
    end

    within "#aid-stations" do
      click_button "Crew access"
    end
    assert_selector "#station_pass_aid_station_#{@inbound.id}[hidden]", visible: :all

    prefer_reduced_motion
    within "[data-terrain-map-target='detail']" do
      click_link "Full station pass"
    end

    assert_equal "#station_pass_aid_station_#{@inbound.id}", page.evaluate_script("window.location.hash")
    within "#aid-stations" do
      assert_selector "button[aria-pressed='true']", text: /All/i
      assert_text /Showing 2 station passes/i
      assert_selector "#station_pass_aid_station_#{@outbound.id}:not([hidden])"
      assert_selector "#station_pass_aid_station_#{@inbound.id}:not([hidden])"
    end
    assert_selector "#station_pass_aid_station_#{@inbound.id} details[open]"
    assert_no_selector "#station_pass_aid_station_#{@outbound.id} details[open]"
    within "#station_pass_aid_station_#{@inbound.id}" do
      assert_text "10:00 PM / 37h"
      assert_text "Approach from Red Grade Road."
      assert_text "High-clearance vehicles recommended."
      assert_text /Verification:\s+Verified source/i
      assert_link "Open map"
    end
    assert_selector "#station_pass_aid_station_#{@inbound.id} summary:focus"
    assert_scrolled_to "#station_pass_aid_station_#{@inbound.id}"
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

  test "terrain success exposes interactive controls" do
    visit race_path(@race)
    assert_selector "[data-terrain-map-target='status']", text: /DEM/

    within "#course" do
      assert_selector "[role='img'][aria-label*='terrain map'] canvas"
      assert_checked_field "Course"
      assert_checked_field "Station passes"
      assert_button "Top view"
      assert_button "Reset view"
      assert_text "Select a station pass"
    end
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
    history_length = page.evaluate_script("window.history.length")

    prefer_reduced_motion
    within "#crew" do
      click_link "Show crew drive on map"
    end

    assert_equal "#course", page.evaluate_script("window.location.hash")
    assert_equal history_length, page.evaluate_script("window.history.length")
    assert_checked_field "Crew drive"
    assert_scrolled_to "#course"
  end

  test "crew passes action filters the canonical station table" do
    visit race_path(@race)

    history_length = page.evaluate_script("window.history.length")
    prefer_reduced_motion
    within "#crew" do
      click_link "Crew-accessible passes"
    end

    assert_equal "#aid-stations", page.evaluate_script("window.location.hash")
    assert_equal history_length, page.evaluate_script("window.history.length")
    within "#aid-stations" do
      assert_selector "button[aria-pressed='true']", text: /Crew access/i
      assert_text /Showing 1 station pass/i
      assert_selector "#station_pass_aid_station_#{@outbound.id}:not([hidden])"
      assert_selector "#station_pass_aid_station_#{@inbound.id}[hidden]", visible: :all
    end
    assert_scrolled_to "#aid-stations"
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

  def assert_scrolled_to(selector)
    top = page.evaluate_script("document.querySelector('#{selector}').getBoundingClientRect().top")

    assert_operator top, :>=, -1
    assert_operator top, :<=, 120
  end

  def prefer_reduced_motion
    page.execute_script <<~JAVASCRIPT
      window.matchMedia = () => ({ matches: true })
      document.documentElement.style.scrollBehavior = "auto"
    JAVASCRIPT
  end
end

require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @race = Race.create!(name: "Bighorn 100", slug: "bighorn-100", year: 2026, state: "WY", distance_mi: 100.4)
  end

  test "landing explains Ultrainfo and presents Bighorn as the first complete record" do
    get root_path

    assert_response :success
    assert_select "h1", /Ultra race information/i
    assert_select "h2", /Bighorn 100/i
    assert_select "[data-controller='terrain-map'][data-terrain-map-preview-value='true']", count: 1
    assert_select "[data-controller='map']", count: 0
    assert_select "a[href=?]", race_path(@race)
    assert_select "a[href='https://github.com/turbothad/ultrainfo']", /GitHub/i
    refute_includes response.body, "Choose your role"
    refute_includes response.body, "Plotting the course"
  end
end

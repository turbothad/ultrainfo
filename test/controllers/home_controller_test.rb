require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @race = Race.create!(name: "Bighorn 100", slug: "bighorn-100", year: 2026, state: "WY", distance_mi: 100.4)
  end

  test "landing leads with the featured race and the three role doors" do
    get root_path
    assert_response :success
    assert_select "h1", /Bighorn 100/i
    assert_select "a[href=?]", race_path(@race, anchor: "runner")
    assert_select "a[href=?]", race_path(@race, anchor: "crew")
    assert_select "a[href=?]", race_path(@race, anchor: "follower")
  end
end

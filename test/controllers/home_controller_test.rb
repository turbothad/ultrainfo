require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @race = Race.create!(name: "Bighorn 100", slug: "bighorn-100", year: 2026, state: "WY", distance_mi: 100.4)
  end

  test "landing links into canonical race sections without role-page navigation" do
    get root_path

    assert_response :success
    assert_select "h1", /Bighorn 100/i
    assert_select "a[href=?]", race_path(@race, anchor: "aid-stations")
    assert_select "a[href=?]", race_path(@race, anchor: "crew")
    assert_select "a[href=?]", race_path(@race, anchor: "follow")
    assert_select "a[href$='#runner']", 0
    assert_select "a[href$='#follower']", 0
    assert_select "header nav a[href=?]", race_path(@race), 1
  end
end

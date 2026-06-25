require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "landing page leads with the event and the three role doors" do
    get root_path
    assert_response :success
    assert_select "h1", /Western States/i
    assert_select "a[href=?]", runner_path
    assert_select "a[href=?]", crew_path
    assert_select "a[href=?]", follow_path
  end

  test "runner page renders" do
    get runner_path
    assert_response :success
    assert_select "h1", /Run it/i
  end

  test "crew page renders" do
    get crew_path
    assert_response :success
    assert_select "h1", /Crew/i
  end

  test "follow page renders" do
    get follow_path
    assert_response :success
    assert_select "h1", /Follow/i
  end
end

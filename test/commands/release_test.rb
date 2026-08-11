require "test_helper"
require "open3"

class ReleaseCommandTest < ActiveSupport::TestCase
  test "rejects an invalid semantic version before repository checks" do
    _output, error, status = Open3.capture3(
      Rails.root.join("bin/release").to_s,
      "check",
      "v1.0.0-01"
    )

    assert_not status.success?
    assert_includes error, "invalid SemVer tag: v1.0.0-01"
    assert_not_includes error, "working tree"
  end
end

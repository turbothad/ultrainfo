require "test_helper"
require "open3"
require "tmpdir"

class DockerEntrypointTest < ActiveSupport::TestCase
  test "publishes canonical event bundles before starting the Rails server" do
    Dir.mktmpdir("docker-entrypoint") do |directory|
      bin_directory = File.join(directory, "bin")
      FileUtils.mkdir_p(bin_directory)
      fake_rails = File.join(bin_directory, "rails")
      calls = File.join(directory, "calls")
      File.write(fake_rails, <<~SH)
        #!/bin/sh
        echo "$*" >> "$ENTRYPOINT_CALLS"
      SH
      FileUtils.chmod(0o755, fake_rails)

      _output, error, status = Open3.capture3(
        { "ENTRYPOINT_CALLS" => calls },
        Rails.root.join("bin/docker-entrypoint").to_s,
        "./bin/rails",
        "server",
        chdir: directory
      )

      assert status.success?, error
      assert_equal [ "db:prepare db:seed", "server" ], File.readlines(calls, chomp: true)
    end
  end
end

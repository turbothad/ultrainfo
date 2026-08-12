require "test_helper"

module Terrain
  class ArtifactTest < ActiveSupport::TestCase
    setup do
      @public_root = Rails.root.join("tmp/terrain-test", "#{Process.pid}-#{SecureRandom.hex(6)}", "public")
      @output = @public_root.join("terrain/example-100.json")
      FileUtils.rm_rf(@public_root)
    end

    teardown { FileUtils.rm_rf(@public_root) }

    test "writes a versioned artifact with a stable SHA-256 reference" do
      artifact = Artifact.write(valid_payload, to: @output)

      reference = artifact.reference(path: "/terrain/example-100.json")
      written = JSON.parse(File.read(@output))

      assert_equal Artifact::SCHEMA_VERSION, written.fetch("schema_version")
      assert_equal Artifact::PROJECTION, written.fetch("projection")
      assert_equal Digest::SHA256.file(@output).hexdigest, reference.fetch("sha256")
      assert_equal Artifact::SCHEMA_VERSION, reference.fetch("schema_version")
      assert_equal Artifact::PROJECTION.fetch("type"), reference.fetch("projection")
      assert_equal "/terrain/example-100.json", reference.fetch("path")
      assert_equal reference, artifact.reference(path: "/terrain/example-100.json")
      assert_raises(FrozenError) { artifact.data.fetch("grid")["size"] = 3 }
    end

    test "rejects an artifact whose grid violates the contract" do
      payload = valid_payload
      payload.fetch("grid")["elevations_ft"] = [ 4_000 ]

      error = assert_raises(Artifact::Invalid) { Artifact.write(payload, to: @output) }

      assert_match(/grid elevations/i, error.message)
      assert_not @output.exist?
    end

    test "rejects an artifact without generation metadata" do
      payload = valid_payload.except("generated_at")

      error = assert_raises(Artifact::Invalid) { Artifact.write(payload, to: @output) }

      assert_match(/generated at/i, error.message)
    end

    test "rejects a course grade segment without renderer coordinates" do
      payload = valid_payload
      payload.fetch("course_grade_profile").fetch("segments").first.delete("from")

      error = assert_raises(Artifact::Invalid) { Artifact.write(payload, to: @output) }

      assert_match(/segment from coordinates/i, error.message)
      assert_not @output.exist?
    end

    test "reads only the owned artifact declared by a matching reference" do
      written = Artifact.write(valid_payload, to: @output)

      loaded = Artifact.read(
        written.reference(path: "/terrain/example-100.json"),
        from: @output,
        race_slug: "example-100"
      )

      assert_equal written.sha256, loaded.sha256
      assert_equal "example-100", loaded.data.dig("race", "slug")
    end

    test "rejects stale Race metadata when the artifact bytes change" do
      written = Artifact.write(valid_payload, to: @output)
      reference = written.reference(path: "/terrain/example-100.json")
      File.binwrite(@output, File.binread(@output).sub("Example 100", "Changed 100"))

      error = assert_raises(Artifact::Invalid) do
        Artifact.read(reference, from: @output, race_slug: "example-100")
      end

      assert_match(/SHA-256/i, error.message)
    end

    private

    def valid_payload
      {
        "race" => { "slug" => "example-100", "name" => "Example 100", "year" => 2026 },
        "generated_at" => "2026-08-12T12:00:00Z",
        "source" => {
          "label" => "Terrain source",
          "url" => "https://example.test/terrain",
          "attribution" => "Example terrain data"
        },
        "grid" => {
          "size" => 2,
          "zoom" => 11,
          "bounds" => { "min_lat" => 44.0, "max_lat" => 45.0, "min_lng" => -108.0, "max_lng" => -107.0 },
          "min_ft" => 4_000,
          "max_ft" => 4_300,
          "elevations_ft" => [ 4_000, 4_100, 4_200, 4_300 ]
        },
        "course_grade_profile" => {
          "segments" => [ {
            "from" => [ 44.0, -108.0 ],
            "to" => [ 45.0, -107.0 ],
            "grade_pct" => 8.5,
            "steepness" => "moderate"
          } ]
        }
      }
    end
  end
end

require "test_helper"
require "tmpdir"

module Events
  class ImportTest < ActiveSupport::TestCase
    test "publishes the version-controlled Active event catalog" do
      published_races = Import.new(Rails.root.join("db/events/active.yml")).call

      assert_equal [ "Bighorn 100" ], published_races.map(&:name)
      race = published_races.first
      assert_equal 20_500, race.elevation_gain_ft
      assert_equal Date.new(2026, 6, 19), race.start_date
      assert_equal Date.new(2026, 6, 20), race.end_date
      assert race.closed?
      assert_equal "https://bighorntrailrun.com/results-%26-timing-1", race.results_url
      assert_equal "verified", race.source_metadata["verification_status"]
      assert_equal 600, race.simplified_track.size
      assert_equal 22, race.aid_stations.count
      assert race.aid_stations.all?(&:coordinates?), "every Station pass gets coordinates from a course waypoint"
      assert_equal "30h", race.aid_stations.find_by!(mile: 82.5).cutoff_elapsed_label
      assert_equal 4, race.crew_route["legs"].size
    end

    test "publishes every Race in the explicit Active event catalog" do
      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "first-hundred", name: "First Hundred")
        write_bundle(directory, slug: "second-hundred", name: "Second Hundred")
        write_catalog(catalog_path, %w[first-hundred.bundle.yml second-hundred.bundle.yml])

        published_races = Import.new(catalog_path).call

        assert_equal [ "First Hundred", "Second Hundred" ], published_races.map(&:name)
        assert_equal [ "first-hundred", "second-hundred" ], Race.order(:slug).pluck(:slug)
        assert published_races.all? { |race| race.aid_stations.one? }
      end
    end

    test "leaves the published Races unchanged when a required bundle file is missing" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "first-hundred", name: "First Hundred")
        write_bundle(directory, slug: "broken-hundred", name: "Broken Hundred")
        write_catalog(catalog_path, %w[first-hundred.bundle.yml broken-hundred.bundle.yml])
        File.delete(File.join(directory, "broken-hundred.gpx"))

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "broken-hundred.gpx is missing", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "rejects an owned artifact whose declared SHA-256 digest does not match" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "changed-hundred", name: "Changed Hundred")
        write_catalog(catalog_path, %w[changed-hundred.bundle.yml])
        File.write(File.join(directory, "terrain/changed-hundred.json"), JSON.generate("version" => 2))

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "changed-hundred.json SHA-256 does not match", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "rejects an Event bundle when a Station pass has no matching course waypoint" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "unmatched-hundred", name: "Unmatched Hundred")
        write_catalog(catalog_path, %w[unmatched-hundred.bundle.yml])
        race_path = File.join(directory, "unmatched-hundred.yml")
        data = YAML.load_file(race_path, permitted_classes: [ Date ], aliases: true)
        data.fetch("aid_stations").first["match"] = "Not in the course"
        File.write(race_path, data.to_yaml)
        refresh_digest(directory, "unmatched-hundred", "race")

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "Station pass Start has no course waypoint matching", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "requires a generated Terrain artifact to be declared by its Event bundle" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "unowned-hundred", name: "Unowned Hundred")
        write_catalog(catalog_path, %w[unowned-hundred.bundle.yml])
        manifest_path = File.join(directory, "unowned-hundred.bundle.yml")
        manifest = YAML.load_file(manifest_path)
        manifest.fetch("files").delete("terrain")
        File.write(manifest_path, manifest.to_yaml)

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "generated Terrain artifact is not declared", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "requires the declared Terrain artifact to match the runtime path" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "misdirected-hundred", name: "Misdirected Hundred")
        write_catalog(catalog_path, %w[misdirected-hundred.bundle.yml])
        race_path = File.join(directory, "misdirected-hundred.yml")
        data = YAML.load_file(race_path, permitted_classes: [ Date ], aliases: true)
        data.fetch("race").fetch("terrain_artifacts")["path"] = "/terrain/different.json"
        File.write(race_path, data.to_yaml)
        refresh_digest(directory, "misdirected-hundred", "race")

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "declared Terrain artifact does not match its runtime path", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "requires a generated crew route to be declared by its Event bundle" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "unrouted-hundred", name: "Unrouted Hundred")
        write_catalog(catalog_path, %w[unrouted-hundred.bundle.yml])
        manifest_path = File.join(directory, "unrouted-hundred.bundle.yml")
        manifest = YAML.load_file(manifest_path)
        manifest.fetch("files").delete("crew_route")
        File.write(manifest_path, manifest.to_yaml)

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "generated crew route is not declared", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "rejects a bundle whose manifest and Race record name different slugs" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "identity-hundred", name: "Identity Hundred")
        write_catalog(catalog_path, %w[identity-hundred.bundle.yml])
        manifest_path = File.join(directory, "identity-hundred.bundle.yml")
        manifest = YAML.load_file(manifest_path)
        manifest["slug"] = "another-hundred"
        File.write(manifest_path, manifest.to_yaml)

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "manifest slug another-hundred does not match Race slug identity-hundred", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "rejects duplicate Races in the Active event catalog before publication" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "duplicate-hundred", name: "Duplicate Hundred")
        write_catalog(catalog_path, %w[duplicate-hundred.bundle.yml duplicate-hundred.bundle.yml])

        error = assert_raises(Import::InvalidCatalog) { Import.new(catalog_path).call }

        assert_match "duplicate Race slug duplicate-hundred", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "rejects an unsupported Event bundle manifest version" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "future-hundred", name: "Future Hundred")
        write_catalog(catalog_path, %w[future-hundred.bundle.yml])
        manifest_path = File.join(directory, "future-hundred.bundle.yml")
        manifest = YAML.load_file(manifest_path)
        manifest["version"] = 2
        File.write(manifest_path, manifest.to_yaml)

        error = assert_raises(Import::InvalidBundle) { Import.new(catalog_path).call }

        assert_match "unsupported Event bundle version 2", error.message
        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    test "removes Races absent from the Active event catalog" do
      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "remaining-hundred", name: "Remaining Hundred")
        write_bundle(directory, slug: "retired-hundred", name: "Retired Hundred")
        write_catalog(catalog_path, %w[remaining-hundred.bundle.yml retired-hundred.bundle.yml])
        Import.new(catalog_path).call
        write_catalog(catalog_path, %w[remaining-hundred.bundle.yml])

        published_races = Import.new(catalog_path).call

        assert_equal [ "remaining-hundred" ], published_races.map(&:slug)
        assert_equal [ "remaining-hundred" ], Race.pluck(:slug)
      end
    end

    test "replaces a Race projection without retaining facts removed from its Event bundle" do
      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "changing-hundred", name: "Changing Hundred")
        write_catalog(catalog_path, %w[changing-hundred.bundle.yml])
        race_path = File.join(directory, "changing-hundred.yml")
        data = YAML.load_file(race_path, permitted_classes: [ Date ], aliases: true)
        data.fetch("race")["official_url"] = "https://example.com/old"
        File.write(race_path, data.to_yaml)
        refresh_digest(directory, "changing-hundred", "race")
        Import.new(catalog_path).call
        data.fetch("race").delete("official_url")
        File.write(race_path, data.to_yaml)
        refresh_digest(directory, "changing-hundred", "race")

        published_race = Import.new(catalog_path).call.first

        assert_nil published_race.official_url
        assert_equal 1, Race.where(slug: "changing-hundred").count
      end
    end

    test "validates every Race projection before publication writes begin" do
      existing = Race.create!(name: "Already Published", slug: "already-published", year: 2025)

      with_event_catalog do |catalog_path, directory|
        write_bundle(directory, slug: "valid-hundred", name: "Valid Hundred")
        write_bundle(directory, slug: "invalid-hundred", name: "Invalid Hundred")
        write_catalog(catalog_path, %w[valid-hundred.bundle.yml invalid-hundred.bundle.yml])
        race_path = File.join(directory, "invalid-hundred.yml")
        data = YAML.load_file(race_path, permitted_classes: [ Date ], aliases: true)
        data.fetch("race").delete("name")
        File.write(race_path, data.to_yaml)
        refresh_digest(directory, "invalid-hundred", "race")

        assert_raises(ActiveRecord::RecordInvalid) { Import.new(catalog_path).call }

        assert_equal [ existing.id ], Race.pluck(:id)
      end
    end

    private

    def with_event_catalog
      Dir.mktmpdir("event-catalog") do |directory|
        yield File.join(directory, "active.yml"), directory
      end
    end

    def write_catalog(path, manifests)
      File.write(path, { "active_event_bundles" => manifests }.to_yaml)
    end

    def write_bundle(directory, slug:, name:)
      files = {
        "race" => "#{slug}.yml",
        "course" => "#{slug}.gpx",
        "crew_route" => "#{slug}.crew_route.json",
        "terrain" => "terrain/#{slug}.json"
      }

      FileUtils.mkdir_p(File.dirname(File.join(directory, files.fetch("terrain"))))
      File.write(File.join(directory, files.fetch("race")), {
        "race" => {
          "name" => name,
          "slug" => slug,
          "year" => 2026,
          "terrain_artifacts" => {
            "status" => "generated",
            "path" => "/terrain/#{slug}.json"
          }
        },
        "elevation_series" => [],
        "crew_drive_order" => [ "Start" ],
        "aid_stations" => [ {
          "match" => "Start",
          "name" => "Start",
          "mile" => 0,
          "elev" => 5_000,
          "crew" => true,
          "pacer" => false,
          "drop" => false,
          "food" => true,
          "med" => false
        } ]
      }.to_yaml)
      File.write(File.join(directory, files.fetch("course")), <<~GPX)
        <gpx>
          <wpt lat="44.0" lon="-107.0"><name>Start</name></wpt>
          <trk><trkseg>
            <trkpt lat="44.0" lon="-107.0" />
            <trkpt lat="45.0" lon="-108.0" />
          </trkseg></trk>
        </gpx>
      GPX
      File.write(File.join(directory, files.fetch("crew_route")), JSON.generate("legs" => []))
      File.write(File.join(directory, files.fetch("terrain")), JSON.generate("version" => 1))

      manifest = {
        "version" => 1,
        "slug" => slug,
        "files" => files.transform_values do |file|
          path = File.join(directory, file)
          { "path" => file, "sha256" => Digest::SHA256.file(path).hexdigest }
        end
      }
      File.write(File.join(directory, "#{slug}.bundle.yml"), manifest.to_yaml)
    end

    def refresh_digest(directory, slug, role)
      manifest_path = File.join(directory, "#{slug}.bundle.yml")
      manifest = YAML.load_file(manifest_path)
      declaration = manifest.fetch("files").fetch(role)
      declaration["sha256"] = Digest::SHA256.file(File.join(directory, declaration.fetch("path"))).hexdigest
      File.write(manifest_path, manifest.to_yaml)
    end
  end
end

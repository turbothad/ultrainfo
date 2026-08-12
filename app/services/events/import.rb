module Events
  # Publishes the explicit Active event catalog as one atomic runtime snapshot.
  class Import
    class InvalidCatalog < StandardError; end
    class InvalidBundle < StandardError; end

    Projection = Data.define(:race, :aid_stations)

    def initialize(catalog_path)
      @catalog_path = Pathname(catalog_path)
    end

    def call
      projections = load_projections
      validate_projections!(projections)

      Race.transaction do
        Race.destroy_all
        projections.map { |projection| publish(projection) }
      end
    end

    private

    def load_projections
      catalog = YAML.load_file(@catalog_path, permitted_classes: [ Date ], aliases: true)
      projections = catalog.fetch("active_event_bundles").map do |manifest_path|
        load_projection(@catalog_path.dirname.join(manifest_path))
      end
      duplicate_slug = projections.map { |projection| projection.race.fetch("slug") }.tally.find do |_slug, count|
        count > 1
      end&.first
      raise InvalidCatalog, "duplicate Race slug #{duplicate_slug}" if duplicate_slug

      projections
    end

    def load_projection(manifest_path)
      manifest = YAML.load_file(manifest_path, permitted_classes: [ Date ], aliases: true)
      version = manifest.fetch("version")
      raise InvalidBundle, "unsupported Event bundle version #{version}" unless version == 1

      declarations = manifest.fetch("files")
      files = declarations.transform_values do |declaration|
        manifest_path.dirname.join(declaration.fetch("path"))
      end
      files.each do |role, path|
        raise InvalidBundle, "#{path.basename} is missing" unless path.file?

        expected_digest = declarations.fetch(role).fetch("sha256")
        actual_digest = Digest::SHA256.file(path).hexdigest
        raise InvalidBundle, "#{path.basename} SHA-256 does not match its declaration" unless actual_digest == expected_digest
      end
      data = YAML.load_file(files.fetch("race"), permitted_classes: [ Date ], aliases: true)
      manifest_slug = manifest.fetch("slug")
      race_slug = data.fetch("race").fetch("slug")
      if manifest_slug != race_slug
        raise InvalidBundle, "manifest slug #{manifest_slug} does not match Race slug #{race_slug}"
      end
      validate_artifact_declarations!(data, files)
      validate_terrain_artifact!(data, files, race_slug)
      gpx = Gpx::Import.new(files.fetch("course"))
      endpoints = gpx.endpoints

      race = data.fetch("race").merge(
        "start_lat" => endpoints.fetch(:start).first,
        "start_lng" => endpoints.fetch(:start).last,
        "finish_lat" => endpoints.fetch(:finish).first,
        "finish_lng" => endpoints.fetch(:finish).last,
        "simplified_track" => gpx.track(600),
        "elevation_series" => data.fetch("elevation_series").map do |mile, feet|
          { "mile" => mile, "elevation_ft" => feet }
        end,
        "crew_route" => files["crew_route"] && JSON.parse(files.fetch("crew_route").read)
      )
      aid_stations = data.fetch("aid_stations").each_with_index.map do |station, index|
        match = station.fetch("match")
        waypoint = gpx.waypoint(match)
        raise InvalidBundle, "Station pass #{station.fetch("name")} has no course waypoint matching #{match.inspect}" if waypoint.nil?

        station_attributes(station, index, waypoint)
      end

      Projection.new(race:, aid_stations:)
    end

    def validate_terrain_artifact!(data, files, race_slug)
      reference = data.fetch("race").fetch("terrain_artifacts", {})
      return if reference.blank?

      Terrain::Artifact.read(reference, from: files.fetch("terrain"), race_slug: race_slug)
    end

    def validate_artifact_declarations!(data, files)
      terrain = data.fetch("race").fetch("terrain_artifacts", {})
      if terrain["status"] == "generated" && !files.key?("terrain")
        raise InvalidBundle, "generated Terrain artifact is not declared"
      end
      if terrain["status"] == "generated"
        runtime_path = terrain["path"]
        unless runtime_path.is_a?(String) && runtime_path.start_with?("/terrain/") &&
            files.fetch("terrain").expand_path.to_s.end_with?(runtime_path)
          raise InvalidBundle, "declared Terrain artifact does not match its runtime path"
        end
      end

      if data["crew_drive_order"].present? && !files.key?("crew_route")
        raise InvalidBundle, "generated crew route is not declared"
      end
    end

    def validate_projections!(projections)
      projections.each do |projection|
        race = Race.new(projection.race)
        race.valid?
        race.errors.delete(:slug, :taken)
        raise ActiveRecord::RecordInvalid, race if race.errors.any?

        projection.aid_stations.each do |attributes|
          station_pass = race.aid_stations.build(attributes)
          raise ActiveRecord::RecordInvalid, station_pass unless station_pass.valid?
        end
      end
    end

    def station_attributes(station, index, waypoint)
      {
        name: station["name"], sequence: index + 1, mile: station["mile"], elevation_ft: station["elev"],
        cutoff: station["cutoff"], crew_accessible: station["crew"], pacer_access: station["pacer"],
        drop_bag: station["drop"], has_water: true, has_food: station["food"], has_medical: station["med"],
        parking_notes: station["park"], lat: waypoint&.fetch(:lat), lng: waypoint&.fetch(:lng),
        source_metadata: station["source_metadata"] || {}, direction: station["direction"],
        aid_notes: station["aid"], bathroom_notes: station["bathroom"], crew_access_notes: station["crew_notes"],
        pacer_notes: station["pacer_notes"], directions_notes: station["directions"], road_notes: station["road"],
        cutoff_clock: station["cutoff_clock"], cutoff_elapsed_minutes: station["cutoff_elapsed_minutes"],
        access_notes: station["access"]
      }
    end

    def publish(projection)
      race = Race.create!(projection.race)
      projection.aid_stations.each { |attributes| race.aid_stations.create!(attributes) }
      race
    end
  end
end

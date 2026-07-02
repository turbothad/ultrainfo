module Events
  # Seeds one race from its data files in db/events/: <slug>.yml (facts), <slug>.gpx
  # (course + waypoint coords), and an optional cached <slug>.crew_route.json.
  # Adding an event = adding data files and re-running `bin/rails db:seed` — no new code.
  class Import
    def initialize(yml_path)
      @dir = File.dirname(yml_path)
      @data = YAML.load_file(yml_path, permitted_classes: [ Date ])
      @slug = @data.fetch("race").fetch("slug")
    end

    def call
      gpx = Gpx::Import.new(File.join(@dir, "#{@slug}.gpx"))
      ends = gpx.endpoints

      Race.where(slug: @slug).destroy_all # idempotent reseed
      race = Race.create!(@data["race"].merge(
        "start_lat" => ends[:start][0], "start_lng" => ends[:start][1],
        "finish_lat" => ends[:finish][0], "finish_lng" => ends[:finish][1],
        "simplified_track" => gpx.track(600),
        "elevation_series" => @data["elevation_series"].map { |mile, ft| { "mile" => mile, "elevation_ft" => ft } }
      ))

      @data["aid_stations"].each_with_index do |s, i|
        wpt = gpx.waypoint(s["match"])
        warn "  ! no GPX waypoint matched #{s["match"].inspect}" if wpt.nil?
        race.aid_stations.create!(
          name: s["name"], sequence: i + 1, mile: s["mile"], elevation_ft: s["elev"], cutoff: s["cutoff"],
          crew_accessible: s["crew"], pacer_access: s["pacer"], drop_bag: s["drop"],
          has_water: true, has_food: s["food"], has_medical: s["med"],
          parking_notes: s["park"], lat: wpt&.dig(:lat), lng: wpt&.dig(:lng)
        )
      end

      route = crew_route(gpx)
      race.update!(crew_route: route) if route
      race
    end

    private

    # Cached to a committed file so re-seeds stay offline after the first OSRM fetch.
    def crew_route(gpx)
      order = @data["crew_drive_order"] or return nil
      file = File.join(@dir, "#{@slug}.crew_route.json")
      return JSON.parse(File.read(file)) if File.exist?(file)

      waypoints = order.filter_map { |m| w = gpx.waypoint(m); [ w[:lat], w[:lng] ] if w }
      route = Routing::Osrm.route(waypoints)
      File.write(file, JSON.pretty_generate(route)) if route
      route
    end
  end
end

module Gpx
  # Parses a GPX file into map data. Reusable per race — drop db/events/<slug>.gpx and call.
  # ponytail: Nokogiri (already bundled with Rails) instead of the `gpx` gem — GPX is plain XML.
  class Import
    FT_PER_M = 3.28084

    def initialize(path)
      doc = Nokogiri::XML(File.read(path))
      doc.remove_namespaces!
      @doc = doc
    end

    # Decimated [[lat, lng], …] for the course polyline (14k raw points → ~max).
    def track(max = 600)
      pts = @doc.xpath("//trkpt").map { |n| [ n["lat"].to_f.round(6), n["lon"].to_f.round(6) ] }
      decimate(pts, max)
    end

    # Named waypoints (Bighorn's are the aid stations, with real coords).
    def waypoints
      @doc.xpath("//wpt").map do |w|
        ele = w.at_xpath("ele")&.text
        {
          name: w.at_xpath("name")&.text.to_s,
          lat: w["lat"].to_f.round(6),
          lng: w["lon"].to_f.round(6),
          ele_ft: ele.present? ? (ele.to_f * FT_PER_M).round : nil
        }
      end
    end

    def waypoint(name_includes)
      waypoints.find { |w| w[:name].include?(name_includes) }
    end

    def endpoints
      first = @doc.at_xpath("//trkpt")
      last = @doc.xpath("//trkpt").last
      {
        start: [ first["lat"].to_f.round(6), first["lon"].to_f.round(6) ],
        finish: [ last["lat"].to_f.round(6), last["lon"].to_f.round(6) ]
      }
    end

    private

    def decimate(arr, n)
      return arr if arr.size <= n
      step = (arr.size - 1).to_f / (n - 1)
      (0...n).map { |i| arr[(i * step).round] }
    end
  end
end

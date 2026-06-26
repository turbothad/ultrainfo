require "net/http"
require "json"

module Routing
  # Driving route through ordered [lat, lng] waypoints via the public OSRM demo server.
  # ponytail: OSRM demo (router.project-osrm.org) is fine for one cached fetch per event; self-host
  # or move to OpenRouteService if usage grows. Returns nil on any failure so callers fall back to
  # straight segments + "Get directions" links — never block a page render on routing.
  class Osrm
    HOST = "router.project-osrm.org".freeze

    # waypoints: [[lat, lng], …] in drive order. Returns a Hash (string keys) or nil.
    def self.route(waypoints, max_points: 400)
      return nil if waypoints.compact.size < 2

      coords = waypoints.map { |lat, lng| "#{lng},#{lat}" }.join(";")
      uri = URI("https://#{HOST}/route/v1/driving/#{coords}?overview=full&geometries=geojson")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = 8
      http.read_timeout = 25
      res = http.get(uri.request_uri)
      return nil unless res.is_a?(Net::HTTPSuccess)

      r = JSON.parse(res.body).dig("routes", 0) or return nil
      {
        "geometry" => decimate(r.dig("geometry", "coordinates").map { |lng, lat| [ lat.round(6), lng.round(6) ] }, max_points),
        "distance_mi" => (r["distance"] / 1609.34).round(1),
        "duration_min" => (r["duration"] / 60.0).round,
        "legs" => (r["legs"] || []).map { |l| { "distance_mi" => (l["distance"] / 1609.34).round(1), "duration_min" => (l["duration"] / 60.0).round } }
      }
    rescue StandardError => e
      Rails.logger.warn("Routing::Osrm failed: #{e.message}") if defined?(Rails)
      nil
    end

    def self.decimate(arr, n)
      return arr if arr.size <= n
      step = (arr.size - 1).to_f / (n - 1)
      (0...n).map { |i| arr[(i * step).round] }
    end
  end
end

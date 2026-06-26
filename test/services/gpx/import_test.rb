require "test_helper"
require "tempfile"

class Gpx::ImportTest < ActiveSupport::TestCase
  GPX = <<~XML
    <?xml version="1.0"?>
    <gpx xmlns="http://www.topografix.com/GPX/1/1">
      <wpt lat="44.1" lon="-107.1"><name>Dry Fork Ridge (13.4M)</name><ele>2280</ele></wpt>
      <trk><trkseg>
        <trkpt lat="44.0" lon="-107.0"></trkpt>
        <trkpt lat="44.1" lon="-107.1"></trkpt>
        <trkpt lat="44.2" lon="-107.2"></trkpt>
      </trkseg></trk>
    </gpx>
  XML

  def with_gpx
    Tempfile.create([ "course", ".gpx" ]) do |f|
      f.write(GPX)
      f.flush
      yield Gpx::Import.new(f.path)
    end
  end

  test "track returns lat/lng pairs and decimates to the cap" do
    with_gpx do |g|
      assert_equal [ [ 44.0, -107.0 ], [ 44.1, -107.1 ], [ 44.2, -107.2 ] ], g.track
      assert_equal 2, g.track(2).size
    end
  end

  test "waypoint matches by name and converts elevation to feet" do
    with_gpx do |g|
      w = g.waypoint("Dry Fork")
      assert_equal [ 44.1, -107.1 ], [ w[:lat], w[:lng] ]
      assert_in_delta 7480, w[:ele_ft], 5 # 2280 m → ~7480 ft
    end
  end

  test "endpoints are the first and last track points" do
    with_gpx do |g|
      assert_equal [ 44.0, -107.0 ], g.endpoints[:start]
      assert_equal [ 44.2, -107.2 ], g.endpoints[:finish]
    end
  end
end

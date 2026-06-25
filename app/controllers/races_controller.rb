class RacesController < ApplicationController
  before_action :set_race

  def show; end
  def runner; end
  def crew; end
  def follow; end

  # GeoJSON-ish payload that feeds the Leaflet crew map.
  # Tested directly (races_controller_test) so the map is verified through its data.
  def map
    render json: {
      course: @race.simplified_track,
      start: { lat: @race.start_lat, lng: @race.start_lng, name: @race.start_venue },
      stations: @race.aid_stations.map do |s|
        {
          name: s.name, mile: s.mile, sequence: s.sequence,
          crew: s.crew_accessible, pacer: s.pacer_access, drop_bag: s.drop_bag,
          cutoff: s.cutoff, parking: s.parking_notes,
          lat: s.lat, lng: s.lng
        }
      end
    }
  end

  private

  def set_race
    @race = Race.find_by!(slug: params[:slug])
  end
end

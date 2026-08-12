class RacesController < ApplicationController
  before_action :set_race

  def show
    @race.aid_stations.load
    @station_passes = @race.aid_stations.sort_by { |station| station.sequence || 0 }.map { |station| StationPassPresentation.call(station) }
  end

  def runner
    redirect_to race_path(@race, anchor: "aid-stations"), status: :moved_permanently
  end

  def crew
    redirect_to race_path(@race, anchor: "crew"), status: :moved_permanently
  end

  def follow
    redirect_to race_path(@race, anchor: "follow"), status: :moved_permanently
  end

  # Terrain-ready payload for the race map.
  # Tested directly (races_controller_test) so the map is verified through its data.
  def map
    unless request.format.json?
      return redirect_to race_path(@race, anchor: "course"), status: :moved_permanently
    end

    render json: {
      race: {
        name: @race.name, slug: @race.slug, year: @race.year,
        distance_mi: @race.distance_mi, elevation_gain_ft: @race.elevation_gain_ft,
        elevation_loss_ft: @race.elevation_loss_ft,
        source_metadata: @race.source_metadata
      },
      course: @race.simplified_track,
      crew_route: @race.crew_route,
      terrain_artifacts: terrain_artifacts_payload,
      start: { lat: @race.start_lat, lng: @race.start_lng, name: @race.start_venue },
      stations: @race.aid_stations.map { |station| StationPassPresentation.call(station) }
    }
  end

  private

  def set_race
    @race = Race.find_by!(slug: params[:slug])
  end

  def terrain_artifacts_payload
    return {} if @race.terrain_artifacts.blank?

    Terrain::Artifact.runtime_reference(@race.terrain_artifacts)
  end
end

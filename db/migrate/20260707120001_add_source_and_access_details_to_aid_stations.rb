class AddSourceAndAccessDetailsToAidStations < ActiveRecord::Migration[8.1]
  def change
    add_column :aid_stations, :source_metadata, :json, default: {}, null: false
    add_column :aid_stations, :direction, :string
    add_column :aid_stations, :aid_notes, :text
    add_column :aid_stations, :bathroom_notes, :text
    add_column :aid_stations, :crew_access_notes, :text
    add_column :aid_stations, :pacer_notes, :text
    add_column :aid_stations, :directions_notes, :text
    add_column :aid_stations, :road_notes, :text
    add_column :aid_stations, :cutoff_clock, :string
    add_column :aid_stations, :cutoff_elapsed_minutes, :integer
  end
end

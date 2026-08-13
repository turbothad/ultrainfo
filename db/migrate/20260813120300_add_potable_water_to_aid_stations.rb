class AddPotableWaterToAidStations < ActiveRecord::Migration[8.1]
  def change
    add_column :aid_stations, :potable_water, :boolean
  end
end

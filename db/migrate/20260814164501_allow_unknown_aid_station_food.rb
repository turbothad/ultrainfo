class AllowUnknownAidStationFood < ActiveRecord::Migration[8.1]
  def change
    change_column_default :aid_stations, :has_food, from: false, to: nil
    change_column_null :aid_stations, :has_food, true
  end
end

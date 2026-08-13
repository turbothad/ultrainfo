class AllowUnspecifiedAidStationWater < ActiveRecord::Migration[8.1]
  def change
    change_column_default :aid_stations, :has_water, from: true, to: nil
    change_column_null :aid_stations, :has_water, true
  end
end

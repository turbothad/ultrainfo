class AllowUnspecifiedAidStationDropBag < ActiveRecord::Migration[8.1]
  def change
    change_column_default :aid_stations, :drop_bag, from: false, to: nil
    change_column_null :aid_stations, :drop_bag, true
  end
end

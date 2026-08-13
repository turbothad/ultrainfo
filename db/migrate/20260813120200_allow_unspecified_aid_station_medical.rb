class AllowUnspecifiedAidStationMedical < ActiveRecord::Migration[8.1]
  def change
    change_column_default :aid_stations, :has_medical, from: false, to: nil
    change_column_null :aid_stations, :has_medical, true
  end
end

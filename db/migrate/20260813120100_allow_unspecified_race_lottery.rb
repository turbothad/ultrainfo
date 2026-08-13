class AllowUnspecifiedRaceLottery < ActiveRecord::Migration[8.1]
  def change
    change_column_default :races, :lottery, from: false, to: nil
    change_column_null :races, :lottery, true
  end
end

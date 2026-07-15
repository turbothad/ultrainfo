class AddFollowFieldsToRaces < ActiveRecord::Migration[8.1]
  def change
    add_column :races, :time_zone, :string
    add_column :races, :results_url, :string
  end
end

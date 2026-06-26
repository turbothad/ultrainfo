class AddCrewRouteToRaces < ActiveRecord::Migration[8.1]
  def change
    add_column :races, :crew_route, :json
  end
end

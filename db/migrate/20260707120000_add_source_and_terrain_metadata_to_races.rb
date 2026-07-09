class AddSourceAndTerrainMetadataToRaces < ActiveRecord::Migration[8.1]
  def change
    add_column :races, :source_metadata, :json, default: {}, null: false
    add_column :races, :terrain_artifacts, :json, default: {}, null: false
  end
end

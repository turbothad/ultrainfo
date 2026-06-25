class CreateAidStations < ActiveRecord::Migration[8.1]
  def change
    create_table :aid_stations do |t|
      t.references :race, null: false, foreign_key: true
      t.string  :name, null: false
      t.integer :sequence
      t.decimal :mile, precision: 6, scale: 2
      t.integer :elevation_ft
      t.string  :cutoff
      t.boolean :crew_accessible, null: false, default: false
      t.boolean :pacer_access,    null: false, default: false
      t.boolean :drop_bag,        null: false, default: false
      t.boolean :has_water,       null: false, default: true
      t.boolean :has_food,        null: false, default: false
      t.boolean :has_medical,     null: false, default: false
      t.text    :parking_notes
      t.text    :access_notes
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :lng, precision: 10, scale: 6

      t.timestamps
    end
    add_index :aid_stations, [ :race_id, :sequence ]
  end
end

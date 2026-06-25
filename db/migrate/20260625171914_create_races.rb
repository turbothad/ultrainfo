class CreateRaces < ActiveRecord::Migration[8.1]
  def change
    create_table :races do |t|
      t.string  :name, null: false
      t.string  :slug, null: false
      t.integer :year, null: false
      t.string  :state
      t.decimal :distance_mi, precision: 6, scale: 2
      t.integer :elevation_gain_ft
      t.integer :elevation_loss_ft
      t.date    :start_date
      t.date    :end_date
      t.string  :start_time
      t.decimal :cutoff_hours, precision: 5, scale: 2
      t.string  :official_url
      t.string  :registration_url
      t.integer :registration_status, null: false, default: 0
      t.string  :tracking_url
      t.string  :tracking_provider
      t.boolean :lottery, null: false, default: false
      t.string  :blurb
      t.text    :about
      t.string  :start_venue
      t.string  :finish_venue
      t.decimal :start_lat,  precision: 10, scale: 6
      t.decimal :start_lng,  precision: 10, scale: 6
      t.decimal :finish_lat, precision: 10, scale: 6
      t.decimal :finish_lng, precision: 10, scale: 6
      t.json    :simplified_track, default: []
      t.json    :elevation_series, default: []

      t.timestamps
    end
    add_index :races, :slug, unique: true
  end
end

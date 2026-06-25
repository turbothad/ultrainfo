# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_25_171915) do
  create_table "aid_stations", force: :cascade do |t|
    t.text "access_notes"
    t.datetime "created_at", null: false
    t.boolean "crew_accessible", default: false, null: false
    t.string "cutoff"
    t.boolean "drop_bag", default: false, null: false
    t.integer "elevation_ft"
    t.boolean "has_food", default: false, null: false
    t.boolean "has_medical", default: false, null: false
    t.boolean "has_water", default: true, null: false
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "lng", precision: 10, scale: 6
    t.decimal "mile", precision: 6, scale: 2
    t.string "name", null: false
    t.boolean "pacer_access", default: false, null: false
    t.text "parking_notes"
    t.integer "race_id", null: false
    t.integer "sequence"
    t.datetime "updated_at", null: false
    t.index ["race_id", "sequence"], name: "index_aid_stations_on_race_id_and_sequence"
    t.index ["race_id"], name: "index_aid_stations_on_race_id"
  end

  create_table "races", force: :cascade do |t|
    t.text "about"
    t.string "blurb"
    t.datetime "created_at", null: false
    t.decimal "cutoff_hours", precision: 5, scale: 2
    t.decimal "distance_mi", precision: 6, scale: 2
    t.integer "elevation_gain_ft"
    t.integer "elevation_loss_ft"
    t.json "elevation_series", default: []
    t.date "end_date"
    t.decimal "finish_lat", precision: 10, scale: 6
    t.decimal "finish_lng", precision: 10, scale: 6
    t.string "finish_venue"
    t.boolean "lottery", default: false, null: false
    t.string "name", null: false
    t.string "official_url"
    t.integer "registration_status", default: 0, null: false
    t.string "registration_url"
    t.json "simplified_track", default: []
    t.string "slug", null: false
    t.date "start_date"
    t.decimal "start_lat", precision: 10, scale: 6
    t.decimal "start_lng", precision: 10, scale: 6
    t.string "start_time"
    t.string "start_venue"
    t.string "state"
    t.string "tracking_provider"
    t.string "tracking_url"
    t.datetime "updated_at", null: false
    t.integer "year", null: false
    t.index ["slug"], name: "index_races_on_slug", unique: true
  end

  add_foreign_key "aid_stations", "races"
end

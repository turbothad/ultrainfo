require "test_helper"

class RaceTest < ActiveSupport::TestCase
  test "valid with name, slug, year" do
    assert Race.new(name: "X", slug: "x-100", year: 2026).valid?
  end

  test "requires name, slug, year" do
    race = Race.new
    assert_not race.valid?
    assert race.errors[:name].any?
    assert race.errors[:slug].any?
    assert race.errors[:year].any?
  end

  test "slug must be unique and url-safe" do
    Race.create!(name: "A", slug: "bighorn-100", year: 2026)
    assert_not Race.new(name: "B", slug: "bighorn-100", year: 2027).valid?, "duplicate slug"
    assert_not Race.new(name: "C", slug: "Bad Slug", year: 2026).valid?, "non url-safe slug"
  end

  test "to_param is the slug" do
    assert_equal "bighorn-100", Race.new(slug: "bighorn-100").to_param
  end

  test "registration_status defaults to not_open" do
    assert Race.new.not_open?
  end

  test "aid_stations are ordered by sequence" do
    race = Race.create!(name: "A", slug: "a-100", year: 2026)
    race.aid_stations.create!(name: "Second", sequence: 2)
    race.aid_stations.create!(name: "First", sequence: 1)
    assert_equal %w[First Second], race.aid_stations.map(&:name)
  end

  test "station location counts distinguish locations from race passes" do
    race = Race.create!(name: "A", slug: "a-100", year: 2026)
    race.aid_stations.create!(name: "Dry Fork", sequence: 1, crew_accessible: true)
    race.aid_stations.create!(name: "Sally's", sequence: 2, crew_accessible: true)
    race.aid_stations.create!(name: "Dry Fork", sequence: 3, crew_accessible: true)
    race.aid_stations.create!(name: "Bear Camp", sequence: 4, crew_accessible: false)

    assert_equal 3, race.aid_station_location_count
    assert_equal 2, race.crew_location_count
  end

  test "race date label handles single day and multi-day ranges" do
    helper = Class.new { include ApplicationHelper }.new

    assert_equal "Date TBD", helper.race_date_label(Race.new)
    assert_equal "June 19, 2026", helper.race_date_label(Race.new(start_date: Date.new(2026, 6, 19)))
    assert_equal "June 19 - 20, 2026", helper.race_date_label(
      Race.new(start_date: Date.new(2026, 6, 19), end_date: Date.new(2026, 6, 20))
    )
    assert_equal "June 30 - July 1, 2026", helper.race_date_label(
      Race.new(start_date: Date.new(2026, 6, 30), end_date: Date.new(2026, 7, 1))
    )
    assert_equal "December 31, 2026 - January 1, 2027", helper.race_date_label(
      Race.new(start_date: Date.new(2026, 12, 31), end_date: Date.new(2027, 1, 1))
    )
  end
end

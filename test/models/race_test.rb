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
end

class Race < ApplicationRecord
  has_many :aid_stations, -> { order(:sequence) }, dependent: :destroy

  enum :registration_status,
       { not_open: 0, lottery: 1, open: 2, waitlist: 3, closed: 4, sold_out: 5 },
       default: :not_open

  validates :name, :year, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }

  # Pretty URLs: /races/bighorn-100
  def to_param = slug

  # The registration enum also has a `lottery` value, so give the event-level
  # boolean an explicit domain name instead of relying on `self[:lottery]`.
  def lottery_required? = self[:lottery]

  def aid_station_location_count
    aid_stations.map(&:name).uniq.size
  end

  def crew_location_count
    aid_stations.select(&:crew_accessible?).map(&:name).uniq.size
  end

  def starts_at
    zone = Time.find_zone(time_zone)
    return if zone.nil? || start_date.blank? || start_time.blank?

    zone.parse("#{start_date} #{start_time}")
  rescue ArgumentError
    nil
  end

  def turnaround_cutoff_at
    station = aid_stations.find { |aid_station| aid_station.direction == "Turnaround" }
    return if station.nil? || starts_at.nil?
    return starts_at + station.cutoff_elapsed_minutes.minutes if station.cutoff_elapsed_minutes.present?

    clock_time_after_start(station.cutoff_clock)
  end

  def final_cutoff_at
    starts_at && cutoff_hours && starts_at + cutoff_hours.hours
  end

  private

  def clock_time_after_start(clock)
    return if clock.blank?

    time = Time.find_zone(time_zone).parse("#{start_date} #{clock}")
    time < starts_at ? time + 1.day : time
  rescue ArgumentError
    nil
  end
end

class Race < ApplicationRecord
  has_many :aid_stations, -> { order(:sequence) }, dependent: :destroy

  enum :registration_status,
       { not_open: 0, lottery: 1, open: 2, waitlist: 3, closed: 4, sold_out: 5 },
       default: :not_open

  validates :name, :year, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }

  # Pretty URLs: /races/bighorn-100
  def to_param = slug
end

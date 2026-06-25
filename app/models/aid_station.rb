class AidStation < ApplicationRecord
  belongs_to :race

  validates :name, presence: true

  scope :ordered, -> { order(:sequence) }
  scope :crew, -> { where(crew_accessible: true) }

  # Has a plottable point on the course map.
  def coordinates? = lat.present? && lng.present?
end

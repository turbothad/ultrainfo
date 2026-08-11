class AidStation < ApplicationRecord
  belongs_to :race

  validates :name, presence: true

  scope :ordered, -> { order(:sequence) }
  scope :crew, -> { where(crew_accessible: true) }

  # Has a plottable point on the course map.
  def coordinates? = lat.present? && lng.present?

  def turnaround? = direction == "Turnaround"

  def cutoff_elapsed_label
    return if cutoff_elapsed_minutes.blank?

    hours = cutoff_elapsed_minutes / 60
    minutes = cutoff_elapsed_minutes % 60
    minutes.zero? ? "#{hours}h" : "#{hours}h #{minutes}m"
  end
end

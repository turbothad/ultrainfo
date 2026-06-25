class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :featured_race

  private

  # The single race we feature in the nav/footer/landing today.
  # Becomes a picker (or a races index) once there's more than one.
  def featured_race
    @featured_race ||= Race.order(:year).first
  end
end

class HomeController < ApplicationController
  # Role-first landing. Features the first onboarded race while the catalog is small.
  def index
    @race = featured_race
  end
end

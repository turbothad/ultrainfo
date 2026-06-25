class HomeController < ApplicationController
  # Role-first landing. Features the one race we have today (Bighorn 100).
  def index
    @race = featured_race
  end
end

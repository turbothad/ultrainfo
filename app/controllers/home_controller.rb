class HomeController < ApplicationController
  # Featured-race landing while the catalog is small.
  def index
    @race = featured_race
    @race&.aid_stations&.load
  end
end

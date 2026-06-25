Rails.application.routes.draw do
  # Health check for load balancers / uptime monitors.
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  # A race and its role-first views. Pretty slugs: /races/bighorn-100/crew
  resources :races, only: [ :show ], param: :slug do
    member do
      get :runner
      get :crew
      get :follow
      get :map   # JSON payload for the Leaflet crew map (RacesController#map)
    end
  end
end

Rails.application.routes.draw do

  resources :weather_readings
  resources :weather_stations
  root "weather_readings#index"
end

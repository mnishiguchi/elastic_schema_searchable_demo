Rails.application.routes.draw do

  resources :schema_searches, only: [:index]
  root "schema_searches#index"
end

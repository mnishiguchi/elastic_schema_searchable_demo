Rails.application.routes.draw do

  get "schema_search"        => "schema_searches#search"
  get "schema_search/detail" => "schema_searches#detail"

  root "schema_searches#search"
end

class SchemaSearchesController < ApplicationController

  def index
    search = SchemaSearch.new(search_params).search

    @results        = search[:results]
    # @active_filters = active_filters(search_params)
    # @json_for_map    = search[:json_for_map]
  end

  private def search_params
    # TODO: make a whitelist.
    params.permit!
  end
end

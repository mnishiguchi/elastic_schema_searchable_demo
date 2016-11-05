class SchemaSearchesController < ApplicationController

  def search
    search   = SchemaSearch.new(schema_search_params).search
    @results = search[:results]
  end

  def detail
    @object = params[:type].classify.constantize.find(params[:id])
  end

  private def schema_search_params
    # TODO: make a whitelist.
    params.permit!
  end
end

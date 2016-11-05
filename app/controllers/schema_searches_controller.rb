class SchemaSearchesController < ApplicationController

  def search
    search   = SchemaSearch.new(schema_search_params).search
    @results = search[:results]
    @active_filters = active_filters
  end

  def detail
    @object = params[:type].classify.constantize.find(params[:id])
  end

  private def active_filters
    slice = [
      "q",
      "class_name",
      "sort_attribute",
      "sort_order",
    ]
    schema_search_params.to_h.slice(*slice).reject { |_, v| v.blank? }
  end

  private def schema_search_params
    # TODO: make a whitelist.
    params.permit!
  end
end

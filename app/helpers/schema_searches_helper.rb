module SchemaSearchesHelper

  def schema_searches_title
    "#{pluralize(@results.count, "record")} found"
  end


  # ---
  # Search meta
  # ---


  def active_filters_text(active_filters)

    # TODO

  end

  def sort_text(active_filters)

    # TODO

  end

  def class_names_text(active_filters)
    # "Reading type: #{active_filters[:searchable_class_names]}" if active_filters[:searchable_class_names].present?
  end


  # ---
  # Filtering
  # ---


  def active_filters(params)
    # @search_params.slice(
    #   :class_name
    # ).to_h.reject { |_, v| v.blank? }
  end

  def class_name_select_tag(params)
    options = SchemaSearch.searchable_class_names
    select_tag(
      "class_name",
      options_for_select(options, params[:class_name]),
      include_blank: true
    )
  end


  # ---
  # Sorting
  # ---


  def sort_attribute_select_tag(params)
    # NOTE: For some reason, sorting by id key does not work. Therefore, we use
    # joint strings of class_name and id for that purpose.
    options = {
      "class_name"  => "class_name_with_id",
      "created_at"  => "created_at",
      "updated_at"  => "updated_at",
    }
    select_tag(
      "sort_attribute",
      options_for_select(options, params[:sort_attribute]),
      include_blank: false
    )
  end

  def sort_order_select_tag(params)
    options = {
      "Ascending"  => "asc",
      "Descending" => "desc"
    }
    select_tag(
      "sort_order",
      options_for_select(options, params[:sort_order]),
      include_blank: false
    )
  end

end

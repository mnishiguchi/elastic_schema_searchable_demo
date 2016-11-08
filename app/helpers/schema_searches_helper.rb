module SchemaSearchesHelper
  
  # ---
  # Search meta
  # ---


  def total_count_text(results)
    "#{pluralize(results.try!(:total_count), "record")} found"
  end


  def q_text(filter_hash)
    if filter_hash["q"]&.present?
      filter_hash["q"]
    end
  end

  def class_name_text(filter_hash)
    if filter_hash["type"]&.present?
      filter_hash["type"]
    end
  end

  def sort_attribute_text(filter_hash)
    if filter_hash["sort_attribute"]&.present?
      filter_hash["sort_attribute"]
    end
  end

  def sort_order_text(filter_hash)
    if filter_hash["sort_order"]&.present?
      filter_hash["sort_order"]
    end
  end


  # ---
  # Filtering
  # ---


  def class_name_select_tag(params)
    options = SchemaSearch.searchable_class_names
    select_tag(
      "type",
      options_for_select(options, params[:type]),
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

module WeatherReadingsHelper

  def weather_readings_title
    "#{pluralize(@weather_readings.count, "reading")} found"
  end


  # ---
  # Search meta
  # ---


  def active_filters_text(active_filters)
    return "" if active_filters.values.all?(&:blank?)

    [].tap do |sc_text|
      sc_text << "("
      sc_text << reading_value_text(active_filters)
      sc_text << reading_type_text(active_filters)
      sc_text << sort_text(active_filters)
      sc_text.compact!
      sc_text << ")"
    end.join("")
  end

  private def reading_value_text(active_filters)
    min, max = active_filters[:reading_value_min], active_filters[:reading_value_max]
    if min.present? && max.present?
      "Reading value: #{min} to #{max}"
    elsif min.present?
      "Reading value: Min $#{min}"
    elsif max.present?
      "Reading value: Max $#{max}"
    end
  end

  private def sort_text(active_filters)

    # TODO

  end

  private def reading_type_text(active_filters)
    "Reading type: #{active_filters[:reading_type]}" if active_filters[:reading_type].present?
  end


  # ---
  # Sorting
  # ---


  def sort_attribute_select_tag(params)
    options = {
      "reading_date"  => "reading_date",
      "reading_type"  => "reading_type",
      "reading_value" => "reading_value",
      "source_flag"   => "source_flag",
      "station_name"  => "station_name",
      "station"       => "station",
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


  # ---
  # Filtering
  # ---


  def reading_type_select_tag(params)
    reading_types = WeatherReading.distinct(:reading_type).pluck(:reading_type)
    select_tag(
      "reading_type",
      options_for_select(reading_types, params[:reading_type]),
      include_blank: true
    )
  end

  def bathroom_count_select_tag(params)
    select_tag(
      "bathroom_count",
      options_for_select(%w(1+ 2+ 3+), params[:bathroom_count]),
      include_blank: true
    )
  end
end

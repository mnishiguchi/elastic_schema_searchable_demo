class WeatherReadingsSearch

  private def search_model
    WeatherReading
  end

  # Returns an Searchkick::Results object which responds like an array.
  def initialize(search_params)
    @search_params = search_params
    @query         = search_params[:q].presence || "*"
  end

  # A wrapper of Searchkick's search method. We configure common behavior of
  # all the searches here.
  # arg0: a query string
  # arg1: an @search_params hash
  def search
    # Invoke Searchkick's search method with our search constraints.
    @results ||= search_model.search(@query, search_constraints)

    # Wrap the information as a hash and pass it to PropertiesController.
    {
      results:        @results,
      active_filters: active_filters
    }
  end

  private def search_constraints
    {
      match:        :word_start,
      misspellings: { below: 5 },
      limit: 30,
      where: where,
      order: order,
      page:  @search_params[:page],
      per_page: 20
    }
  end

  # We specify the where clause for the search if needed.
  private def where
    where = {}

    # reading type
    if @search_params[:reading_type].present?
      where[:reading_type] = @search_params[:reading_type]
    end

    # reading date range
    date_regex = /^\d{4}\-\d{2}\-\d{2}$/
    reading_date_min = [
      @search_params[:reading_date_min_year],
      @search_params[:reading_date_min_month],
      @search_params[:reading_date_min_day],
    ].join("-")
    reading_date_max = [
      @search_params[:reading_date_max_year],
      @search_params[:reading_date_max_month],
      @search_params[:reading_date_max_day],
    ].join("-")
    if reading_date_min =~ date_regex  && reading_date_max =~ date_regex
      where[:reading_date] = {
        gte: reading_date_min,
        lte: reading_date_max
      }
    elsif reading_date_min =~ date_regex
      where[:reading_date] = {
        gte: reading_date_min
      }
    elsif reading_date_max =~ date_regex
      where[:reading_date] = {
        lte: reading_date_max
      }
    end

    # reading value range
    if @search_params[:reading_value_min].present? && @search_params[:reading_value_max].present?
      where[:reading_value] = {
        gte: @search_params[:reading_value_min],
        lte: @search_params[:reading_value_max]
      }
    elsif @search_params[:reading_value_min].present?
      where[:reading_value] = {
        gte: @search_params[:reading_value_min]
      }
    elsif @search_params[:reading_value_max].present?
      where[:reading_value] = {
        lte: @search_params[:reading_value_max]
      }
    end

    ap where
    return where
  end

  private def order
    return {} unless @search_params[:sort_attribute].present?

    order = @search_params[:sort_order].presence || :asc
    { @search_params[:sort_attribute] => order }
  end

  private def active_filters
    @search_params.slice( :reading_value_min,
                          :reading_value_max,
                          :reading_type
                        ).to_h.reject { |_, v| v.blank? }
  end
end

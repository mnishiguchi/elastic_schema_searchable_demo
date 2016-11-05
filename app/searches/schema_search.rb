class SchemaSearch

  # Register all the class_names here.
  @@searchable_classes = [
    Admin,
    User,
    AccountExecutive,
    Client
  ]
  @@searchable_class_names ||= @@searchable_classes.map(&:to_s).map(&:underscore)
  cattr_accessor :searchable_class_names

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
    # Searchkick.search "milk", index_name: [Product, Category]
    @results = Searchkick.search(@query, search_constraints)

    ap search_constraints

    # Wrap the information as a hash and pass it to PropertiesController.
    {
      results:        @results,
    }
  end

  private def search_constraints
    {
      match:        :word_middle,
      misspellings: { below: 5 },
      index_name:   @@searchable_classes,
      where:        where,
      order:        order,
      page:         @search_params[:page],
      per_page:     20,
      # limit:        30,
    }
  end

  # We specify the where clause for the search if needed.
  private def where
    where = {}

    # class_name
    if @search_params[:class_name].present?
      where[:class_name] = @search_params[:class_name]
    end

    return where
  end

  private def order
    return {} unless @search_params[:sort_attribute].present?

    order = @search_params[:sort_order].presence || :asc
    { @search_params[:sort_attribute] => order }
  end
end

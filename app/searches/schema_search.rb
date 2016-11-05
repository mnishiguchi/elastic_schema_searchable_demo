class SchemaSearch

  # Register all the class_names that we want to be searchable.
  @@searchable_classes ||= [
    Admin,
    User,
    AccountExecutive,
    Client
  ]
  cattr_accessor :searchable_classes

  # Returns an array of underscored version of the registered class names.
  def self.searchable_class_names
    @@searchable_class_names ||= @@searchable_classes.map(&:to_s).map(&:underscore)
  end

  def initialize(search_params)
    @search_params = search_params
    @query         = search_params[:q].presence || "*"
  end

  # A wrapper of Searchkick's search method.
  def search
    # Invoke Searchkick's search method with our search constraints.
    @results = Searchkick.search(@query, search_constraints)

    # For debuging.
    ap search_constraints if ENV["RAILS_ENV"] == "development"

    # Wrap the information as a hash and pass it to PropertiesController.
    {
      # An Searchkick::Results object which responds like an array.
      results: @results,
    }
  end

  private def search_constraints
    {
      index_name:   @@searchable_classes,
      match:        :word_middle,
      misspellings: { below: 5 },
      where:        where,
      order:        order,
      page:         @search_params[:page],
      per_page:     30,
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

    where
  end

  # Sets the sorting-related constraints based on "sort_attribute" and
  # "sort_order" params.
  private def order
    return {} unless @search_params[:sort_attribute].present?

    order = @search_params[:sort_order].presence || :asc

    {
      @search_params[:sort_attribute] => order
    }
  end
end

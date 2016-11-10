class SchemaSearch
  attr_reader :search_params, :query

  # Returns a list of all the classes that are registered as searchable.
  def self.searchable_classes
    @@searchable_classes ||= begin
      Rails.application.eager_load! if ENV["RAILS_ENV"] == "development"

      ApplicationRecord.descendants.select do |klass|
        # NOTE: set_searchable method is defined in SchemaSearchable module.
        klass.respond_to?(:set_searchable)
      end
    end
  end

  # Returns an array of underscored version of the registered class names.
  def self.searchable_class_names
    @@searchable_class_names ||= self.searchable_classes.map(&:to_s).map(&:underscore)
  end

  def initialize(search_params)
    @search_params = search_params
    @query         = search_params[:q].presence || "*"
  end

  # A wrapper of Searchkick's search method.
  def search
    # Invoke Searchkick's search method with our search constraints.
    results = Searchkick.search(query, search_constraints)

    # For debuging.
    ap search_constraints if ENV["RAILS_ENV"] == "development"

    # Wrap the information as a hash and pass it to PropertiesController.
    {
      # An Searchkick::Results object which responds like an array.
      results:        results,
      active_filters: active_filters,
    }
  end

  private def search_constraints
    {
      index_name:   SchemaSearch.searchable_classes,
      match:        :word_middle,
      misspellings: { below: 5 },
      where:        where,
      order:        order,
      page:         search_params[:page],
      per_page:     30,
      # limit:        30,
    }
  end

  # We specify the where clause for the search if needed.
  private def where
    where = {}

    # class_name_with_id
    if search_params[:type].present?
      where[:class_name_with_id] = /#{search_params[:type]}-[0-9]*/
    end

    where
  end

  # Sets the sorting-related constraints based on "sort_attribute" and
  # "sort_order" params.
  private def order
    return {} unless search_params[:sort_attribute].present?

    order = search_params[:sort_order].presence || :asc

    {
      search_params[:sort_attribute] => order
    }
  end

  # This can be used for displaying active filters in UI.
  private def active_filters
    slice = [
      "q",
      "type",
      "sort_attribute",
      "sort_order",
    ]
    search_params.to_h.slice(*slice).reject { |_, v| v.blank? }
  end
end

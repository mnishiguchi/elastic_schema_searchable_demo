require 'active_support/concern'

# https://github.com/ankane/searchkick#multiple-indices
# Searchkick.search "milk", index_name: [Product, Category]
module SchemaSearchable
  extend ActiveSupport::Concern

  class_methods do
    def set_searchable
      searchkick index_name: self.underscored_class_name
    end

    # Returns a string of underscored class_name.
    def underscored_class_name
      model_name.to_s.underscore
    end
  end

  included do
    # Allows us to control what data is indexed for searching.
    # https://github.com/ankane/searchkick#indexing
    # NOTE: We need to reindex after making changes to the search attributes.
    def search_data
      merge = {
        class_name:         self.class.underscored_class_name,
        class_name_with_id: [
                              self.class.underscored_class_name,
                              self.id.to_s.rjust(5, '0')
                            ].join("-"),
      }
      attributes.merge(merge)
    end
  end
end

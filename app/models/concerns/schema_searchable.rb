require 'active_support/concern'

# https://github.com/ankane/searchkick#multiple-indices
# USAGE:
#   class User < ApplicationRecord
#     include SchemaSearchable
#     set_searchable
#   end
module SchemaSearchable
  extend ActiveSupport::Concern

  class_methods do

    # We add this class methods at the top of the class to bootstrap our search.
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
        # Used for filtering by class_name
        class_name:         self.class.underscored_class_name,
        # Used for sorting by id
        class_name_with_id: self.underscored_class_name_with_id
      }
      attributes.merge(merge)
    end

    def underscored_class_name_with_id
      [
        self.class.underscored_class_name,
        self.id.to_s.rjust(5, '0')
      ].join("-")
    end

    def humanized_class_name_with_id
      "#{self.class.name.underscore.humanize} (ID: #{self.id})"
    end
  end
end

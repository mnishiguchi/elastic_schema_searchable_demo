# https://github.com/ankane/searchkick#multiple-indices
# Searchkick.search "milk", index_name: [Product, Category]
module SchemaSearchable
  extend ActiveSupport::Concern

  module ClassMethods
    def set_searchable
      searchkick index_name: self.index_name
    end

    def index_name
      model_name.to_s.underscore
    end
  end
end

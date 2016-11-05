class User < ApplicationRecord
  include SchemaSearchable
  set_searchable
end

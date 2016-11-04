class Admin < ApplicationRecord
  include SchemaSearchable
  set_searchable
  
end

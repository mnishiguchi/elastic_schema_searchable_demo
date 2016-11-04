class Client < ApplicationRecord
  include SchemaSearchable
  set_searchable
  
  belongs_to :account_executive
end

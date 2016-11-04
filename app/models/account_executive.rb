class AccountExecutive < ApplicationRecord
  include SchemaSearchable
  set_searchable

  has_many :clients
end

class Phrase < ActiveRecord::Base
  has_many :users, through: :histories
end

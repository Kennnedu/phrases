class Phrase < ActiveRecord::Base
  has_many :histories
  has_many :users, through: :histories

  validates :name, presence: true
end

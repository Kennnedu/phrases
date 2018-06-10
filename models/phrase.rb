class Phrase < ActiveRecord::Base
  has_many :words
  has_many :users, through: :words

  validates :current_state, presence: true

  scope :recent_updated, -> { order(updated_at: 'desc') }
end

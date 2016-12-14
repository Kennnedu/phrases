class User < ActiveRecord::Base
  has_many :histories
  has_many :phrases, through: :histories

  validates :username, :password, presence: true
end

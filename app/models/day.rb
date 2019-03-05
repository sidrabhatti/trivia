class Day < ApplicationRecord
  has_many :questions
  has_many :guesses

  validates :token, :order, :play_date, presence: true
end

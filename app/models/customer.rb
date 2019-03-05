# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :guesses, inverse_of: :customer
  has_many :questions, through: :guesses

  validates :person_key, presence: true

  # These two validations are removed in favor of PG unique indexes
  #validates :person_key, uniqueness: true
  #validate :has_no_guesses_or_one_guess_for_each_question, on: :update

  def total_score
    guesses.where(answered_status: Guess::CORRECT_STATUS).count
  end

  def todays_score(day)
    guesses.where(answered_status: Guess::CORRECT_STATUS, day: day).count
  end

  def offer_amount
    format('%.2f', (total_score * 0.25))
  end

  def todays_offer_amount(day)
    format('%.2f', (todays_score(day) * 0.25))
  end

  def has_finished_playing?(day)
    today_guesses = guesses.where(day: day).pluck(:answered_status)
    today_guesses.size > 0 && today_guesses.all? { |answered_status| answered_status != Guess::UNANSWERED_STATUS }
  end

  def has_not_finished_playing?(day)
    !has_finished_playing?(day)
  end

  def unanswered_questions(day)
    guesses.where(day: day).unanswered.includes([:question, :day]).map(&:api_format)
  end
end

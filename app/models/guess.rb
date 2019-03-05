# frozen_string_literal: true

class Guess < ApplicationRecord
  has_secure_token
  belongs_to :day
  belongs_to :customer, inverse_of: :guesses
  belongs_to :question, inverse_of: :guesses

  CORRECT_STATUS = 'correct'
  INCORRECT_STATUS = 'incorrect'
  UNANSWERED_STATUS = 'unanswered'

  ANSWER_STATUSES = [CORRECT_STATUS, INCORRECT_STATUS, UNANSWERED_STATUS].freeze

  validates :answered_status, presence: true, inclusion: { in: ANSWER_STATUSES }
  validates :customer, :question, presence: true

  # Defer this to PG index
  #validates :question, uniqueness: { scope: :customer }

  scope :unanswered, -> { where(answered_status: UNANSWERED_STATUS) }

  def api_format
    correct_answer_position = question.correct_answer_position
    wrong_answers = [
      question.wrong_answer_1,
      question.wrong_answer_2,
      question.wrong_answer_3
    ].shuffle
    choices = wrong_answers.insert(correct_answer_position, question.right_answer)
    {
      question: question.question,
      choices: choices,
      correct: correct_answer_position,
      guessId: token,
      is_image_question: question.is_image_question,
      source: question.description,
      day: day,
      ga_event_category: question.ga_event_action
    }
  end
end

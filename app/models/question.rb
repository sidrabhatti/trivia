# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :day
  has_many :guesses, inverse_of: :question

  validates :right_answer, :wrong_answer_1, :wrong_answer_2, :wrong_answer_3, presence: true

  scope :rows_of_three, -> { all.in_groups_of(3).map(&:compact) }

  def part_image_filepath
    images_dir.join(image_filename)
  end

  def name
    right_answer
  end
end

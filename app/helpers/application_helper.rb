# frozen_string_literal: true

module ApplicationHelper
  def with_question_images_urls(questions)
    questions.map do |question|
      question[:question_image_url] = image_url(question[:question]) if question[:is_image_question]
      question
    end
  end
end

# frozen_string_literal: true

module GuessCreatingService
  module_function

  def ensure_guesses_for_customer(customer, promo_day)
    Question.where(day: promo_day).each do |question|
      begin
        Guess.create!(customer: customer, question: question, day: promo_day)
      rescue ActiveRecord::RecordNotUnique => arnu
        if /unique.*constraint.*index_guesses_on_customer_id_and_question_id_and_day_id/.match?(arnu.message)
          Rails.logger.warn arnu.message
        end
      end
    end
  end
end

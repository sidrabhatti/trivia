# frozen_string_literal: true

class GuessesController < ApplicationController
  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session

  def update
    guess = Guess.find_by!(token: guess_id)
    guess.answered_status = answered_status
    guess.save!
    render json: { status: :ok }
  end

  private

  def guess_id
    params[:id]
  end

  def answered_status
    params[:guess][:answered_status]
  end
end

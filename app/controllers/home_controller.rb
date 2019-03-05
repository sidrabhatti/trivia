# frozen_string_literal: true

class HomeController < ApplicationController
  # TODO: this is for dev convenience, remove it before going live
  def index
    head :ok
  end

  def letsencrypt
    render text: ENV['LETSENCRYPT_KEY']
  end
end

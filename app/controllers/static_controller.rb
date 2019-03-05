# frozen_string_literal: true

class StaticController < ApplicationController
  before_action :check_if_promo_over, except: [:promo_ended]

  def thanks_reply_y; end

  def thanks_already_subscribed; end

  def mobile_only; end

  def error; end

  def promo_ended; end

  def expired_page
  end

  def tap_to_join; end
end

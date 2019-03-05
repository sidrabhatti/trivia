# frozen_string_literal: true

class CustomersController < ApplicationController
  before_action :check_if_promo_over
  before_action :lookup_day, except: :tap_to_join
  before_action :check_if_wrong_day, except: :tap_to_join
  before_action :check_platform, only: [:play, :offer]
  before_action :lookup_customer

  attr_accessor :day, :customer

  def play
    return redirect_to offer_day_customer_path(default_link_params) if customer.has_finished_playing?(day)
    GuessCreatingService.ensure_guesses_for_customer(customer, day)
    @data = {
      questions: customer.unanswered_questions(day),
      offer_href: offer_href
    }
  end

  def offer
    if customer.has_not_finished_playing?(day)
      return redirect_to play_day_customer_path(default_link_params)
    else
      customer.custom_fields["played_day_#{day.order}"] = true
      customer.save!
      custom_fields = {
        trivia_total_score: customer.total_score
      }
      MobiledbSyncWorker.perform_async(customer.id, custom_fields)
    end
    @offer_page = day.is_last_day? ? 'last_day_offer_page' : 'offer_page'
  end

  def tap_to_join; end

  private

  def lookup_day
    self.day = Day.find_by! token: day_token
  end

  def day_token
    params[:day_token]
  end

  def check_if_wrong_day
    return redirect_to static_expired_page_path if wrong_day?
  end

  def wrong_day?
    datetime.to_date != day.play_date
  end

  def lookup_customer
    self.customer = CustomerManagementService.ensure_customer_record!(person_key)
  rescue VibesPersonNotFoundError => e
    Rails.logger.error "[MSG][ERROR] customer not found | person_key: #{person_key}"
    redirect_to static_error_path
  end

  def check_platform
    return redirect_to static_mobile_only_path unless browser.device.mobile?
  end

  def offer_href
    offer_day_customer_path(default_link_params)
  end

  def default_link_params
    attrs = {
      day_token: day.token,
      person_key: customer.person_key
    }
    attrs[:fake_datetime] = params[:fake_datetime] if params[:fake_datetime].present?
    attrs
  end
end

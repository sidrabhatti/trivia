# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  [
    CustomerManagementService::VibesPersonNotFoundError,
    ActiveRecord::RecordNotFound
  ].each { |e| rescue_from e, with: :redirect_to_error }

  before_action :set_datetime

  attr_accessor :datetime

  def set_datetime
    self.datetime = Time.zone.now
    self.datetime = fake_datetime if overwrite_datetime
  end

  def overwrite_datetime
    allow_fake_datetime? && fake_datetime.present?
  end

  def allow_fake_datetime?
    ENV['ALLOW_FAKE_DATETIME'].present?
  end

  def fake_datetime
    fd = params[:fake_datetime]
    return nil unless fd.present?
    Time.zone.parse fd
  end

  def check_if_promo_over
    return redirect_to static_promo_ended_path if PromoOverSwitch.is_promo_over?
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def redirect_to_error
    redirect_to static_error_path
  end

  def person_key
    params[:person_key]
  end
end

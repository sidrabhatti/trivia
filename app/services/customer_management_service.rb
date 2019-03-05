# frozen_string_literal: true

module CustomerManagementService
  module_function

  class VibesPersonNotFoundError < StandardError; end

  NOT_FOUND_ERROR_MESSAGES = [
    'PersonErrors::PersonNotFoundByPersonKey',
    'PersonErrors::PersonNotFound'
  ].freeze

  def ensure_customer_record!(person_key)
    local_record = Customer.find_by(person_key: person_key)
    return local_record if local_record

    vibes_record = vibes_record_for_person_key(person_key)
    if vibes_record
      begin
        return create_customer_from_vibes_record!(vibes_record)
      rescue ActiveRecord::RecordInvalid => ari
        if /Person key has already been taken/.match?(ari.message)
          Rails.logger.warn ari.message
          return Customer.find_by(person_key: person_key)
        end
      rescue ActiveRecord::RecordNotUnique => arnu
        if /unique.*constraint.*index_customers_on_person_key/.match?(arnu.message)
          Rails.logger.warn arnu.message
          return Customer.find_by(person_key: person_key)
        end
      end
    else
      raise VibesPersonNotFoundError, "No person found for #{person_key}"
    end
  end

  def create_customer_from_vibes_record!(vibes_record)
    Customer.create!(
      person_key: vibes_record['person_key']
    )
  end

  def vibes_record_for_person_key(person_key)
    person_result = mobiledb_person_by_key(person_key)
    extract_vibes_person_record(person_result)
  end

  def extract_vibes_person_record(person_result)
    if NOT_FOUND_ERROR_MESSAGES.include?(person_result.try(:[], 'errors').try(:first).try(:[], 'message'))
      return nil
    elsif person_result.try(:[], 'person_key')
      return person_result
    end
  end

  def company_key
    ENV['COMPANY_KEY'] || raise('COMPANY_KEY not set, check env_vars')
  end

  def mobiledb_person_by_key(person_key)
    return mobiledb_person_mock(person_key) if mock_platform_calls?

    MobileDb.get_person(company_key, person_key)
  end

  def mock_platform_calls?
    ENV['MOCK_PLATFORM_CALLS'].present?
  end

  def mock_platform_call
    sleep_for_min = ENV['MOCK_PLATFORM_CALL_FOR_X_MIN_MS'] || 500
    sleep_for_max = ENV['MOCK_PLATFORM_CALL_FOR_X_MAX_MS'] || 1000
    sleep_for = rand(sleep_for_min...sleep_for_max) / 1000.0
    Rails.logger.info "[MSG][INFO] CustomerManagementService platform call mock for #{sleep_for} seconds"
    sleep(sleep_for)
    Rails.logger.info '[MSG][INFO] CustomerManagementService platform call return'
  end

  def mobiledb_person_mock(person_key)
    mock_platform_call
    {
      'person_key' => person_key
    }
  end
end

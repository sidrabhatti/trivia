# frozen_string_literal: true

class PromoOverSwitch < ApplicationRecord
  validate :only_one_of_it

  def self.is_promo_over?
    first.is_promo_over
  end

  private

  def only_one_of_it
    if self.class.count > 1
      errors.add(:base, message: 'There should only be one PromoOverSwitch')
    end
  end
end

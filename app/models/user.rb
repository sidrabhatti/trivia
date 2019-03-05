# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  if Rails.env.development?
    devise :database_authenticatable, :recoverable, :registerable,
           :rememberable, :trackable, :validatable, :confirmable
  else
    devise :database_authenticatable, :rememberable, :trackable, :validatable, :confirmable
  end
end

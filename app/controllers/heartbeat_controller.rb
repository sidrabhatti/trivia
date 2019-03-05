# frozen_string_literal: true

class HeartbeatController < ApplicationController
  def heartbeat
    render json: { status: 'OK' }
  end
end

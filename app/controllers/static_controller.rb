class StaticController < ApplicationController

  def home
    Rails.logger.warn("warning message")
  end
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from Exception, :with => :handle_exception

  def handle_exception(e)
    case e
      when SecurityTransgression
        head :forbidden
    end
  end
end

class SecurityTransgression < StandardError; end

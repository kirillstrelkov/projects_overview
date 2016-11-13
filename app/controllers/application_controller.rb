class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_current_datetime

  private

  def set_current_datetime
    if Rails.env.production?
      @current_datetime = DateTime.now
    else
      datetime = params['current_datetime']
      @current_datetime = DateTime.parse(datetime) unless datetime.nil?
      @current_datetime ||= session[:current_datetime]
      if @current_datetime.nil?
        @current_datetime = DateTime.now
      end
      session[:current_datetime] = @current_datetime
    end
  end
end

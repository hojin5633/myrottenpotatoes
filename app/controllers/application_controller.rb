class ApplicationController < ActionController::Base
  before_filter :set_current_user
  protected # prevents method from being invoked by a route
  def set_current_user
    @current_user ||= Moviegoer.find_by_id(session[:user_id])
    #redirect_to login_path and return unless @current_user
  end
end


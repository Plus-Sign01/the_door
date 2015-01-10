class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?
  def authenticate_user!
  	session[:user_return_to] = env['PATH_INFO']
  	redirect_to user_omniauth_authorize_path(:facebook) unless logged_in?
  end


  private
  def logged_in?
  	!!session[:user_id]
  end
  def current_user
  	return unless session[:user_id]
  	@current_user ||= User.find(session[:user_id])
end
def authenticate
	return if logged_in?
	redirect_to root_path, alert: 'Please log in'
end
end


  

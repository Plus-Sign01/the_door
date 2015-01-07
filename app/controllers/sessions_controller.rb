class SessionsController < ApplicationController
	def new
		unless Rails.env.test?
			redirect_to root_url
		end

	end
	def create
		user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
		session[:user_id] = user.id
		redirect_to root_path, notice: 'logged in'
	end

	
	def destroy
		reset_session
		redirect_to root_path, notice: 'logged out'
	
	end
end


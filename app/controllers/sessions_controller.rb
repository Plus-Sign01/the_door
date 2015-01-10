class SessionsController < ApplicationController
	def new
		unless Rails.env.test?
			redirect_to root_url
		end

	end
	def create
		user = User.create_omniauth(env['omniauth.auth'])
		session[:user_id] = user.id
		redirect_to root_path, notice: 'logged in'
	end

	
	def destroy
		session[:user_id] = nil
		redirect_to root_path, notice: 'logged out'
	
	end
end


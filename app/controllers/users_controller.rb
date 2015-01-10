class UsersController < ApplicationController
  before_action :authenticate
  

  def create
    # Facebookでログイン
    if env['omniauth.auth'].present?
      @user = User.from_omniauth(env['omniauth.auth'])
      result = @user.save(context: :facebook_login)
      fb = "Facebook"
    else
      @user = User.new(strong_params)
      result = @user.save
      fb = ""
    end
    if result
      sign_in @user
      flash[:success] = "#{fb}ログインしました。"
      redirect_to @user
    else
      if fb.present?
        redirect_to auth_failure_path
      else
        render 'new'
      end
    end

  def retire
  end
  def destroy
    if current_user.destroy
      reset_session
      redirect_to root_path, notice: '退会しました'
    else
      render :retire
    end
  end
end

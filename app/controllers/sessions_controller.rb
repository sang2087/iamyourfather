class SessionsController < ApplicationController
  def login
  end

  def create
		logger.info "session#{session[:user_id]}"
    user = User.find(session[:user_id]).from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
		reset_session
    redirect_to root_url
  end

end

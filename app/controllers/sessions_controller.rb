class SessionsController < ApplicationController
	GET_POINT_LOGIN_TERM_MINUTE = 10

  def create
		logger.info "session#{session[:user_id]}"
    user = User.find(session[:user_id]).from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id

		#TODO 세션이 유저를 구분할 수 있도록 해야함
		pl = false
		if(session[:login_time].nil? or (!session[:login_time].nil? and (Time.now - session[:login_time]) > GET_POINT_LOGIN_TERM_MINUTE*60))
			puts "Login Point GET"
			pl = PointLog.login user
			session[:login_time] = Time.now
		end
		session[:login_point] = pl

    redirect_to root_url
  end

  def signout
		session[:user_id] = nil
		#reset_session 			#don't do this because session[:login_time] will be reset
    redirect_to root_url
  end
  def destroy
		reset_session 
    redirect_to root_url
  end
end

class SendDataController < ApplicationController
	def data
		data = User.make_gexf session[:user_id]
		render :xml => data 
	end
	def friends_list
		facebook = @user.get_facebook

		friends = []
		unless facebook.nil?
			friends = @user.get_facebook.friends_list
		end
		render :json => friends 
	end
	def get_user

		session_user = User.find(session[:user_id])
		if(params[:user_id] == "0")
			user = session_user
		else
			user = User.find(params[:user_id])
		end

		is_function_possible, limit_point, limit_node_cnt = PointLog.is_function_possible?(session_user, user, params[:code])

		data={
			:user => user,
			:is_function_possible => is_function_possible,
			:limit_point => 0 - limit_point,
			:limit_node_cnt => limit_node_cnt
		}
		render :json => data
	end

	def get_i18n_locale
		render :text => extract_locale_from_accept_language_header
	end
	def send_invitation
		@user.send_invitation(params[:uid])

		render :text => extract_locale_from_accept_language_header
	end
	def facebook_post
		@user.facebook_post_wall
		render :text => "success"
	end

private
	def extract_locale_from_accept_language_header
			request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
	end



end

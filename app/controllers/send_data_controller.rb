class SendDataController < ApplicationController
	def data
		data = User.make_gexf session[:user_id]
		render :xml => data 
	end
	def friends_list
		user = User.find(session[:user_id])
		friends = user.get_facebook.friends_list
		render :json => friends 
	end

	def get_user
		if(params[:user_id] == "0")
			user = User.find(session[:user_id])
		else
			user = User.find(params[:user_id])
		end
		render :json => user 
	end

	def get_i18n_locale
		render :text => extract_locale_from_accept_language_header
	end

private
	def extract_locale_from_accept_language_header
			request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
	end


end

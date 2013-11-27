class ApplicationController < ActionController::Base
  protect_from_forgery
	before_filter :set_i18n_locale, :check_facebook_login

	def set_i18n_locale
		if I18n.available_locales.include?(extract_locale_from_accept_language_header.to_sym)
			I18n.locale = params[:lang] || extract_locale_from_accept_language_header
			puts("locale#{I18n.locale}")
		end
	end

	def get_i18n_locale
		render :text => I18n.locale
	end
	def default_url_option
		{ locale:I18n.locale}
	end

	def check_facebook_login
		@is_session_user = session[:user_id]
		puts "session_user#{@is_session_user}"
		facebook_login = false
		logger.info "!!!!!!!#{session[:user_id]}"
		unless session[:user_id].nil?
			#TODO check token expired time
			begin
				@user = User.find(session[:user_id])
				unless User.find(session[:user_id]).facebook_uid.nil?
					facebook_login = true
				end
			rescue Exception => e
				facebook_login = false
				logger.info("ERROR !!! session[user_id] = #{session[:user_id]} cannot check facebook login")
				logger.info(e.message)
				logger.info(e.backtrace.inspect)
				reset_session
				redirect_to :signout
			end
		end
		@facebook_login = facebook_login
	end

private
	def extract_locale_from_accept_language_header
			request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
	end
end

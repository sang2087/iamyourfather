class ApplicationController < ActionController::Base
  protect_from_forgery
	before_filter :set_i18n_locale

	def set_i18n_locale
		if I18n.available_locales.include?(extract_locale_from_accept_language_header.to_sym)
			I18n.locale = extract_locale_from_accept_language_header
			puts("!!!!#{I18n.locale}")
		end
	end

	def get_i18n_locale
		render :text => I18n.locale
	end
	def default_url_option
		{ locale:I18n.locale}
	end

private
	def extract_locale_from_accept_language_header
			request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
	end
end

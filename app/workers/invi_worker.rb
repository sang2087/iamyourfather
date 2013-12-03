#encoding : utf-8
class InviWorker
	URL = "http://iamyourfamily.com/"

  APP_ID = '215886731905255'
  APP_SECRET =  '96c1ecb73693ad1ce0f6d0c754450c75'
  include Sidekiq::Worker

  def perform(user_id, from_uid, to_uid, from_oauth_token, locale)
    id = "-#{from_uid}@chat.facebook.com"
    to = "-#{to_uid}@chat.facebook.com"
		logger.info "SEND message to #{to}"
		puts "SEND message to #{to}"

		if locale == 'ko'
			body = "당신을 우리 가족에 초대합니다. 아래 링크를 참고하세요!\n#{URL}#{user_id}"
		else
			body = "I wanna make family. Come here.\n#{URL}#{user_id}"
		end
		send_message = Jabber::Message.new to, body

		client = Jabber::Client.new Jabber::JID.new(id)
		client.connect
		client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client, APP_ID, from_oauth_token, APP_SECRET), nil)
		client.send send_message
		client.close

		logger.info "SENDED message to #{to}"
  end
end

class Facebook < ActiveRecord::Base
URL = "http://local.youthhogoo.com/"

	APP_ID = '215886731905255'
 	APP_SECRET =	'96c1ecb73693ad1ce0f6d0c754450c75'
  attr_accessible :gender, :link, :locale, :name, :uid
	def get_user 
		return User.find(self.user_id)
	end

  def friends_list
		begin
    friends = FbGraph::Query.new(
        "SELECT uid, name, pic FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me())"
    ).fetch(:access_token => self.oauth_token)
		rescue Exception => e  
			return -1
			logger.info("ERROR facebook connection")
			logger.info(e.message)
			logger.info(e.backtrace.inspect)
		end

		friends_hash = Hash.new
		0.upto(friends.length-1) do |i|
			friends_hash[friends[i]["uid"]] = i
			friends[i]["joined"] = false
			friends[i]["point"] = 0
		end
		
		facebooks = Facebook.all
		facebooks.each do |facebook|
			index = friends_hash[facebook.uid.to_i]
			unless index.nil?
				friends[index]["joined"] = true
				point = facebook.get_user.point
				friends[index]["point"] = point
			end
		end
		
    return friends.sort_by{|friend| friend["name"]}
  end

  def post_wall user
    fb_user = FbGraph::User.me(self.oauth_token)
		name = "I-AM-YOUR-FATHER"
		message = "#{user.parent.username} is #{user.username}'s father.\nif you make your son click this link."
		description = "I-AM-YOUR-FATHER.\nMake your son.\nEnjoy this funny social game"	
		picture = ""
		begin 
    fb_user.feed!(
      :message => message,
			:picture => picture,
      :link => URL + "#{user.id}",
			:name => name,
      :description => description
    )
		rescue Exception => e  
			logger.info("ERROR !!! #{self.id} cannot feed")
			logger.info(e.message)
			logger.info(e.backtrace.inspect)
		end
  end
	#TODO sidekiq
	def send_invitation user, uid
    from_oauth_token = self.oauth_token

    id = "-#{self.uid}@chat.facebook.com"
    to = "-#{uid}@chat.facebook.com"
		logger.info "SEND message to #{to}"

		client = Jabber::Client.new Jabber::JID.new(id)
		client.connect
		client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client, APP_ID, from_oauth_token, APP_SECRET), nil)
		body = "I wanna make family. Come here.\n#{URL}#{user.id}"
		send_message = Jabber::Message.new to, body
		client.send send_message
		client.close

		logger.info "SENDED message to #{to}"
	end

end

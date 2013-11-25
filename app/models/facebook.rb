class Facebook < ActiveRecord::Base
	URL = "http://i-am-your-father.com/"

	APP_ID = '215886731905255'
 	APP_SECRET =	'96c1ecb73693ad1ce0f6d0c754450c75'
#  attr_accessible :gender, :link, :locale, :name, :uid
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

  def check_friends
		begin
    friends = FbGraph::Query.new(
        "SELECT uid, name, pic FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me())"
    ).fetch(:access_token => self.oauth_token)
		rescue Exception => e  
			return []
			logger.info("ERROR facebook connection")
			logger.info(e.message)
			logger.info(e.backtrace.inspect)
		end

		friends_hash = Hash.new
		0.upto(friends.length-1) do |i|
			friends_hash[friends[i]["uid"]] = i
		end
		ret_hash = Hash.new

		facebooks = Facebook.where("uid IS NOT NULL")
		puts "facebook#{facebooks.inspect}"
		facebooks.each do |facebook|
			index = friends_hash[facebook.uid.to_i]
			unless index.nil?
				puts "FID#{facebook.user_id}"
				ret_hash[facebook.user_id] = true
			end
		end
		
    return ret_hash
  end


  def post_wall user
    fb_user = FbGraph::User.me(self.oauth_token)
		name = "I-AM-YOUR-FATHER"
		if I18n.locale == 'ko' do
			if user.depth.nil?
				message = "제가 집안을 일으켰습니다.\n우리 집안에 참여하시려면 클릭하세요!"
			else
				message = "나의 아버지는 #{user.parent.username}이며, #{user.root.username}의 #{user.depth}대 손입니다.\n우리 집안에 참여하시려면 클릭하세요!"
			end
			description = "I-AM-YOUR-FATHER 내가 니 애비다.\nMake your son.\nEnjoy this funny social game"	
		else
			if user.depth.nil?
				message = "#{user.parent.username} is #{user.username}'s father.\nif you make your son click this link."
			else
				message = "My parent is #{user.parent.username}. and I am #{user.depth.ordinalize} of #{user.root.username}'s father.\nif you want to join my family, click this link."
			end
			description = "I-AM-YOUR-FATHER.\nMake your son.\nEnjoy this funny social game"	
		end
		picture = "#{URL}img/thumb.png" 

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
		if I18n.locale == 'ko'
			body = "당신을 우리 가족에 초대합니다. 아래 링크를 참고하세요!\n#{URL}#{user.id}"
		else
			body = "I wanna make family. Come here.\n#{URL}#{user.id}"
		end
		else
		send_message = Jabber::Message.new to, body
		client.send send_message
		client.close

		logger.info "SENDED message to #{to}"
	end

end

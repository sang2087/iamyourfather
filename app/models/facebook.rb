class Facebook < ActiveRecord::Base
	URL = "http://local.youthhogoo.com/"
  attr_accessible :gender, :link, :locale, :name, :uid
	def get_user 
		return User.find(self.user_id)
	end

  def friends_list
    friends = FbGraph::Query.new(
        "SELECT uid, name, pic FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me())"
    ).fetch(:access_token => self.oauth_token)
		puts friends.inspect

    return friends.sort_by{|friend| friend["name"]}
  end

  def post_wall user
    fb_user = FbGraph::User.me(self.oauth_token)
		name = "I-AM-YOUR-FATHER"
		message = "#{user.parent.username} is #{user.username}'s father.\nif you make your son click this link."
		description = "I-AM-YOUR-FATHER.\nMake your son.\nEnjoy this funny social game"	
		picture = ""
    fb_user.feed!(
      :message => message,
			:picture => picture,
      :link => URL + "#{user.id}",
			:name => name,
      :description => description
    )
  end
end

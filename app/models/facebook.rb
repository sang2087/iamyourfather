#encoding : utf-8
class Facebook < ActiveRecord::Base
	URL = "http://iamyourfamily.com/"
	PAGE_ID = "469742759805428"

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
		name = "I am your Family - 전 세계, 한 가족 되기!"
		tags = Array.new

		if I18n.locale.to_s == 'ko' 
			if user.depth == 0 or user.parent.nil?
				message = "제가 가정을 이뤘습니다.\n저의 가족이 되시려면 클릭하세요!\n\n저의 기부 포인트는 #{user.point}입니다.\n이 포인트는 올 겨울 가족이 필요한 이들에게 따뜻한 선물이 됩니다."
			else
				parent = user.parent
				root = user.root

				unless root.nil?
					root_facebook = root.get_facebook
					unless root_facebook.nil?
						unless root_facebook.uid.nil?
							tags.push(root_facebook.uid)
						end
					end
				end

				unless parent.nil?
					parent_facebook = parent.get_facebook
					unless parent_facebook.nil?
						unless parent_facebook.uid.nil?
							tags.push(parent_facebook.uid)
						end
					end
				end
						
				message = "부모는 #{parent.username}이며, #{root.username}의 #{user.depth}대손입니다.\n참 좋은 부모와 조상을 뒀지요?\n우리 가족에 참여하시려면 링크를 클릭하세요!\n\n저의 기부 포인트는 #{user.point}입니다.\n이 포인트는 올 겨울 가족이 필요한 이들에게 따뜻한 선물이 됩니다."
			end
			description = "I am your Family\n전 세계 한 가족 프로젝트! 페이스북 친구를 넘어 페이스북 가족으로!\n링크에 들어오면 크리스마스에 소년 소녀 가장에게 기부가 됩니다.\n어서와~~"	
		else
			if user.depth==0 or user.parent.nil?
				message = "I make a family.\nJoin my family by click this link!"
			else
				parent = user.parent
				root = user.root
				parent_facebook = parent.get_facebook
				root_facebook = root.get_facebook

				unless root_facebook.nil?
					unless root_facebook.uid.nil?
						tags.push(root_facebook.uid)
					end
				end
				unless parent_facebook.nil?
					unless parent_facebook.uid.nil?
						tags.push(parent_facebook.uid)
					end
				end
					
				message = "My parent is #{parent.username} and my founder is #{root.username}. My donation point is #{user.point}.\nIf you want to join my family click this link."
			end
			description = "I am your Family.\nLet's be a family beyond facebook friends.\nIf you enter this link, you will donate to poor children."	
		end

		picture = "#{URL}img/thumb.png" 

		begin 
			fb_user.feed!(
				:message => message,
				:picture => picture,
				:link => URL + "#{user.id}",
				:name => name,
				:description => description,
				:place => PAGE_ID,
				:tags => tags
			)
		rescue Exception => e  
			logger.info("ERROR !!! #{self.id} cannot feed")
			logger.info(e.message)
			logger.info(e.backtrace.inspect)
		end
  end
	#TODO sidekiq
	def send_invitation user, uid
		facebook = user.get_facebook
		InviWorker.perform_async(user.id, facebook.uid, uid, facebook.oauth_token, I18n.locale.to_s)
	end

end

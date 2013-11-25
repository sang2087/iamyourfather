require 'rubyvis'
require 'json'
require 'rexml/document'
class User < ActiveRecord::Base
#attr_accessible :banner, :color, :facebook_uid, :ip, :point, :username, :ancestry, :node_cnt

	APP_ID = '562260310492321'
  APP_SECRET = '9b209a9e006a2244f69419ee5a2b2355'
	CANVAS_WIDTH = 3200
	CANVAS_HEIGHT = 3200

	has_ancestry 
	has_many :point_logs

	def self.all_tree_set_xy
		self.roots.each do |root|
			self.set_tree_xy root
		end
		puts I18n.locale
	end

	def self.set_tree_xy root
		root.displayX = rand(CANVAS_WIDTH)-(CANVAS_WIDTH/2)
		root.displayY = rand(CANVAS_HEIGHT)-(CANVAS_HEIGHT/2)
		root.save!
		User.node_tree root
	end

	def self.node_tree root
		puts "ROOT_ID#{root.id}"
		count = root.children.size
		if(count == 0)
			return nil
		end

		files= User.json_tree(root.children)

		vis = Rubyvis::Panel.new()
				.width(800)
				.height(800)
				.left(0)
				.right(0)
				.top(0)
				.bottom(0)

		tree = vis.add(Rubyvis::Layout::Tree).
			nodes(Rubyvis.dom(files).root(1).nodes()).
			orient('radial').
			depth(85).
			breadth(180/count)

#		tree.link.add(Rubyvis::Line)

		tree.node.add(Rubyvis::Dot).
		title(lambda {|n| n.node_name})

		#tree.node_label.add(Rubyvis::Label).
		#visible(lambda {|n| n.first_child})

		vis.render

		str= vis.to_svg.to_s

		doc = REXML::Document.new(str)
		ids = Array.new
		dots = Array.new
		doc.elements.each('svg/g/g/a') do |ele|
				id = (ele.attribute("xlink:title").to_s)[1..-1]
				if id == ""
					id = root.id
				end
				ids << id.to_i
		end
		doc.elements.each('svg/g/g/a/circle') do |ele|
				x = (ele.attribute("cx").to_s).to_f
				y = (ele.attribute("cy").to_s).to_f
				dots << {:x => x, :y => y}
		end

		# print all events
		ret =""
		rootX = root.displayX
		rootY = root.displayY
		
		ids.each_with_index do |id, i|
			user=User.find(id)
			user.cx = dots[i][:x]
			user.cy = dots[i][:y]
			user.displayX = rootX + dots[i][:x]
			user.displayY = rootY + dots[i][:y]
			user.save
		end
	end

	def self.json_tree(nodes)
		sub_node = Hash.new
		nodes.each do |node|
			sub_node["n#{node["id"]}"] = json_tree(node.children)
		end
		return sub_node
	end
	  
  def from_omniauth(auth)
		facebook_uid = auth.uid
		user = self
		puts "!AUTH!#{auth}"

		first_facebook_connect = false
		if user.facebook_uid.nil? #유저는 있으나 페북 연동 안됨.
			user_with_facebook = User.find_by_facebook_uid(facebook_uid) #해당 facebook아이디가 있는지 확인
			if user_with_facebook.nil? #해당 facebook id가진 사람 없음
				#FRIST FACEBOOK CONNECT
				#TODO post wall
				first_facebook_connect = true

				facebook = Facebook.new
				facebook.user_id = user.id
				facebook.save!

				user.facebook_id = facebook.id
				user.facebook_uid = auth.uid
				user.username = auth.info.name
				user.picture = auth.info.image
				user.save!

			else
				user = user_with_facebook
			end
		end
		
		facebook = user.get_facebook
		facebook.uid = auth.uid
		facebook.name = auth.info.name
		facebook.gender = auth.extra.raw_info.gender
		facebook.locale = auth.extra.raw_info.locale
		facebook.oauth_token = auth.credentials.token
		facebook.oauth_expires_at = Time.at(auth.credentials.expires_at)
		facebook.save!
	
		user.facebook_uid = auth.uid
		user.username = auth.info.name
		user.save!

		if first_facebook_connect
			user.link_in
			user.facebook_post_wall
		end

		user
  end

	def get_facebook 
		unless self.facebook_id.nil?
			Facebook.find(self.facebook_id)
		else
			return nil
		end
	end

	def facebook_post_wall
		self.get_facebook.post_wall(self)
		PointLog.post_wall self
	end

	def send_invitation uid
		puts "send invi user model"
		self.get_facebook.send_invitation self, uid
		PointLog.invitation self
	end

	def link_in 
		if self.facebook_uid.nil?
			# 그냥 로그인
			PointLog.link_without_fb self
		else
			# 페북 로그인
			PointLog.link_with_fb self	
		end
	end

	def self.make_gexf user_id
		users = User.find(:all, :order => "ancestry")
		user = User.find(user_id)
		unless user.get_facebook.nil?
			friends_hash = User.find(user_id).get_facebook.check_friends
		end
		puts"friends_hash#{friends_hash}"
		
		builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
			xml.gexf('xmlns:viz' => 'http:///www.gexf.net/1.1draft/viz', 'version' => '1.1', 'xmlns' => 'http://www.gexf.net/1.1draft') do
				xml.graph('defaultedgetype' => 'directed', 'idtype' => 'string', 'type' => 'static') do
					xml.attributes("class" => "node", "mode" => "static") do
						xml.attribute("id" => "sign", "title" => "Sign", "type" => "string")
					end
					xml.nodes do 
						users.each do |user|
							xml.node('id' => "#{user.id}", 'label' => "#{user.username}(#{user.node_cnt})") do
								xml.attvalues do 
									if(user.id == user_id.to_i)
										xml.attvalue('for' => "sign","value" => "me")
									elsif(!friends_hash.nil? and !friends_hash["#{user.id}"].nil?)
										xml.attvalue('for' => "sign","value" => "friend")
									else
										xml.attvalue('for' => "sign","value" => "")
									end
								end
								xml['viz'].size('value' => Math.log2(user.node_cnt + 1))
								xml['viz'].color('r' => User.color_r(user.color), 'g' => User.color_g(user.color), 'b' => User.color_b(user.color))
								xml['viz'].position('x' => user.displayX, 'y' => user.displayY,'z' => 0)
							end
						end
					end
					xml.edges do 
						cnt = 0
						users.each do |user|
							unless(user.parent_id.nil?)
								cnt += 1
								xml.edge('id' => "#{cnt}", 'source' => "#{user.parent_id}", 'target' => "#{user.id}")
							end
						end
					end
				end
			end
		end

		builder.to_xml
	end

	def self.get_groups
		roots = User.roots
		roots_id = Array.new

		roots.each do |root|
			roots_id.push(root.id)
		end

		groups = Array.new
		roots_id.each do
			groups.push Array.new
		end

		users = User.all
		users.each do |user|
			index = roots_id.rindex(user.root_id)
			groups[index].push(user.id)  
		end

		groups
	end

	def betray youruser_id
		n_cnt = self.node_cnt

		#원래 조상들 node_cnt 제거
		self.ancestors.each do |ancestor|
			ancestor.node_cnt -= n_cnt
			ancestor.save!
		end

		youruser = User.find(youruser_id)
		self.parent = youruser
		self.save

		#새 조상들 node_cnt 추가
		self.ancestors.each do |ancestor|
			ancestor.node_cnt += n_cnt
			ancestor.save!
		end
		self.color = self.root.color
		self.save

		self.descendants.each do |descentdant|
			descentdant.color = self.color
			descentdant.save!
		end

		PointLog.betray self, youruser
		User.set_tree_xy(self.root)

	end

	def seize youruser_id
		
		youruser = User.find(youruser_id)
		n_cnt = youruser.node_cnt

		#seize 당하는 원래 조상들 node_cnt 제거
		youruser.ancestors.each do |ancestor|
			ancestor.node_cnt -= n_cnt
			ancestor.save!
		end

		youruser.parent = self
		youruser.save

		#새 조상들 node_cnt 추가
		youruser.ancestors.each do |ancestor|
			ancestor.node_cnt += n_cnt
			ancestor.save!
		end

		self.descendants.each do |descentdant|
			descentdant.color = self.color
			descentdant.save!
		end
		PointLog.seize self, youruser
		User.set_tree_xy(self.root)
	end

	def independance
		self.parent = nil
		self.color = "#{100 + rand(156)}/#{100 + rand(156)}/#{100 + rand(156)}"
		self.save

		self.descendants.each do |descentdant|
			descentdant.color = self.color
			descentdant.save!
		end
		PointLog.independance self

		self.rand_display_xy
	end

private
	def rand_display_xy
		self.displayX = rand(CANVAS_WIDTH)-(CANVAS_WIDTH/2)
		self.displayY = rand(CANVAS_HEIGHT)-(CANVAS_HEIGHT/2)
		self.save!
	end
	def self.color_r(color)
		color.split("/")[0]
	end
	def self.color_g(color)
		color.split("/")[1]
	end
	def self.color_b(color)
		color.split("/")[2]
	end

end


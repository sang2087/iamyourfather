require 'rubyvis'
require 'json'
require 'rexml/document'
class User < ActiveRecord::Base
#attr_accessible :banner, :color, :facebook_uid, :ip, :point, :username, :ancestry, :node_cnt

	APP_ID = '562260310492321'
  APP_SECRET = '9b209a9e006a2244f69419ee5a2b2355'
	CANVAS_WIDTH = 800
	CANVAS_HEIGHT = 800

	has_ancestry 
	has_many :point_logs

=begin
	def self.all_tree_set_xy
		children_list = User.children_list

		children_list[nil].each do |root_id|
			User.find(root_id).rand_display_xy
			unless children_list[root_id].nil?
				self.set_tree_xy User.find(root_id), children_list, 'all'
				self.set_tree_xy User.find(root_id), children_list, 'family'
			end
		end
	end
=end

	def self.set_tree_xy root, children_list = nil, type = 'all'
		logger.info "ROOT_ID#{root.id}"
		if(children_list.nil?)
			children_list = User.children_list
		end

		files= User.json_tree(children_list[root.id], children_list)

		if children_list[root.id].nil?
			count = 1
		else
			count = children_list[root.id].size
		end


		vis = Rubyvis::Panel.new()
				.width(800)
				.height(800)
				.left(0)
				.right(0)
				.top(0)
				.bottom(0)
		if(type == 'all')
			tree = vis.add(Rubyvis::Layout::Tree).
				nodes(Rubyvis.dom(files).root(1).nodes()).
				orient('radial').
				depth(85).
				breadth(360/count)
		elsif(type == 'family')
			tree = vis.add(Rubyvis::Layout::Tree).
				nodes(Rubyvis.dom(files).root(1).nodes()).
				orient('top').
				depth(85).
				breadth(180/count)
		end

#		tree.link.add(Rubyvis::Line)

		tree.node.add(Rubyvis::Dot).
		title(lambda {|n| n.node_name})

		#tree.node_label.add(Rubyvis::Label).
		#visible(lambda {|n| n.first_child})

		vis.render

		str= vis.to_svg.to_s

		doc = REXML::Document.new(str)
		id_with_dot = Array.new
		i=0
		doc.elements.each('svg/g/g/a') do |ele|
				id_with_dot[i]=Hash.new
				id = (ele.attribute("xlink:title").to_s)[1..-1]
				if id == ""
					id = root.id
				end
				id_with_dot[i][:id]= id.to_i
				i=i+1
		end
		i=0
		doc.elements.each('svg/g/g/a/circle') do |ele|
				x = (ele.attribute("cx").to_s).to_f
				y = (ele.attribute("cy").to_s).to_f
				id_with_dot[i][:x] = root.displayX+x
				id_with_dot[i][:y] = root.displayY+y
				i=i+1
		end
		id_with_dot
	end

	def self.children_list root = nil
		if root.nil?
			users = User.all
		else
			users = root.subtree
		end

		parents = Hash.new
		users.each do |user|
			if parents[user.parent_id].nil? 
				parents[user.parent_id] = Array.new
			end
			parents[user.parent_id].push(user.id)
		end

		parents
	end
	def self.json_tree(nodes, original)
		puts nodes
		sub_node = Hash.new
		unless nodes.nil?
			nodes.each do |id|
				puts "id #{id} child #{original[id]}"
				sub_node["n#{id}"] = json_tree(original[id], original)
			end
		end
		sub_node
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
				user.banner = auth.info.name
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

	def self.make_json user_id
		users = User.all.order("ancestry")
		user = User.find(user_id)
		unless user.get_facebook.nil?
			friends_hash = User.find(user_id).get_facebook.check_friends
		end
		json = Hash.new
		json["nodes"] = Array.new
		json["edges"] = Array.new
		users.each do |u|
			if (u.id == user_id.to_i)
				mark = "me"
			elsif (!friends_hash.nil? and !friends_hash["#{user.id}"].nil?)
				mark = "friend"
			else
				mark = ""
			end
			json["nodes"] << {
				'id' => "#{u.id}",
				'label' => "#{u.username}(#{user.node_cnt-1})",
				'attributes' => [{
					'attr' => "sign",
					'val' => mark}],
				'size' => Math.log2(u.node_cnt + 1).to_f,
				'color' => "rgba(#{User.color_r(u.color)},#{User.color_g(u.color)},#{User.color_b(u.color)},1.0)",
				'x' => u.displayX.to_f,
				'y' => u.displayY.to_f,
				}
		end
		cnt = 0
		users.each do |u|
			unless(u.parent_id.nil?)
				cnt += 1
				json["edges"] << {
					'id'=> "#{cnt}",
					'sourceID' => "#{u.parent_id}",
					'targetID' => "#{u.id}",
					'attributes' => [],
					'label' => nil
				}
			end
		end
		return json
	end

	def self.make_gexf user_id, type = 'all'
		user=User.find(user_id)
		root=user.root
		id_with_dot = Array.new
		if(type == 'all')
			roots = User.where('ancestry' => nil)
			roots.each do |root|
				id_with_dot += set_tree_xy(root, User.children_list(root), 'all')
			end
		elsif(type == 'family')
			id_with_dot = set_tree_xy(root, User.children_list(root), type)
		end
		
=begin
		if(type == 'all')
			users = User.all.order("ancestry")
			user = User.find(user_id)
		elsif type=='family'
			user = User.find(user_id)
			users = user.root.subtree.order("ancestry")
		end
=end

		unless user.get_facebook.nil?
			friends_hash = user.get_facebook.check_friends
		end

		puts"friends_hash#{friends_hash}"
		users = Array.new
		
		builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
			xml.gexf('xmlns:viz' => 'http:///www.gexf.net/1.1draft/viz', 'version' => '1.1', 'xmlns' => 'http://www.gexf.net/1.1draft') do
				xml.graph('defaultedgetype' => 'directed', 'idtype' => 'string', 'type' => 'static') do
					xml.attributes("class" => "node", "mode" => "static") do
						xml.attribute("id" => "sign", "title" => "Sign", "type" => "string")
						if(type == 'family')
							xml.attribute("id" => "picture", "title" => "Picture", "type" => "string")
						end
					end

					xml.nodes do 
						id_with_dot.each do |iwd|
							user = User.find(iwd[:id])
							users << user
							xml.node('id' => "#{user.id}", 'label' => "#{user.banner}(#{user.node_cnt-1})") do
								xml.attvalues do 
									if(user.id == user_id.to_i)
										xml.attvalue('for' => "sign","value" => "me")
									elsif(!friends_hash.nil? and !friends_hash["#{user.id}"].nil?)
										xml.attvalue('for' => "sign","value" => "friend")
									else
										xml.attvalue('for' => "sign","value" => "")
									end

									if(type == 'family')
										xml.attvalue('for' => "picture","value" => user.picture)
									end

								end
								xml['viz'].size('value' => Math.log2(user.node_cnt + 1))
								xml['viz'].color('r' => User.color_r(user.color), 'g' => User.color_g(user.color), 'b' => User.color_b(user.color))
								xml['viz'].position('x' => iwd[:x], 'y' => iwd[:y],'z' => 0)
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

		puts "end make_gxef"
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
		youruser = User.find(youruser_id)

		n_cnt = self.node_cnt

		#원래 조상들 node_cnt 제거
		self.ancestors.each do |ancestor|
			ancestor.node_cnt -= n_cnt
			ancestor.save!
		end

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
		self_root = self.root

		PointLog.betray self, youruser
		#User.set_tree_xy(self_root, nil, 'family')
		#User.set_tree_xy(self_root, User.children_list(self_root), 'all')
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
		self_root=self.root
		#User.set_tree_xy(self_root, nil, 'family')
		#User.set_tree_xy(self_root, User.children_list(self_root), 'all')
	end

	def independance
		self.parent = nil
		self.color = "#{100 + rand(156)}/#{100 + rand(156)}/#{100 + rand(156)}"
		self.save

		self.descendants.each do |descentdant|
			descentdant.color = self.color
			descentdant.save!
		end
		self.rand_display_xy

		PointLog.independance self
		self_root= self.root

		#User.set_tree_xy(self_root, nil, 'family')
		#User.set_tree_xy(self_root, User.children_list(self_root), 'all')
	end

	def rand_display_xy
		radian = (rand(360) + 1) * Math::PI / 180
		r = 800
		self.displayX = r * Math.cos(radian)
		self.displayY = r * Math.sin(radian)
		self.save!
	end
	def my_rank type
		rank = 0
		rank_type = -1
		user_type = -2
		same_rank = 1
		User.order("#{type} DESC").all.each_with_index do |user , i|
			if(type == 'node_cnt')
				user_type = user.node_cnt
			elsif(type == 'point')
				user_type = user.point
			end

			if(rank_type == user_type)
				same_rank = same_rank + 1
			else
				rank_type = user_type
				rank = rank + same_rank
			end
			if(user == self)
				break
			end
		end
		rank
	end
	def self.all_rank type
		rank = 0
		rank_type = -1
		user_type = -2
		same_rank = 1
		rank_array = Array.new
		User.order("#{type} DESC").all.each_with_index do |user , i|
			if(type == 'node_cnt')
				user_type = user.node_cnt
			elsif(type == 'point')
				user_type = user.point
			end
			if(rank_type == user_type)
				same_rank = same_rank + 1
			else
				rank_type = user_type
				rank = rank + same_rank
				same_rank = 1
			end
			rank_array.push({ 
					:id => user.id,
					:name => user.username,
					:node_cnt => user.node_cnt,
					:point => user.point,
					:rank => rank
				})
		end
		rank_array
	end
private
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


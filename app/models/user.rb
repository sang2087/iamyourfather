class User < ActiveRecord::Base
  attr_accessible :banner, :color, :facebook_uid, :ip, :point, :username, :ancestry, :node_cnt

	APP_ID = '562260310492321'
  APP_SECRET = '9b209a9e006a2244f69419ee5a2b2355'

	has_ancestry 
  
  def from_omniauth(auth)
		facebook_uid = auth.uid
		user = self
		puts "!AUTH!#{auth}"

		if user.facebook_uid.nil?
			user_with_facebook = User.find_by_facebook_uid(facebook_uid)
			if user_with_facebook.nil?
				#FRIST FACEBOOK CONNECT
				#TODO post wall
				user.facebook_uid = auth.uid
				user.username = auth.info.name
				user.save!

				facebook = Facebook.new
				facebook.user_id = user.id
				facebook.save!

				user.facebook_id = facebook.id
				user.save!

				user.facebook_post_wall
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

		user
  end

	def get_facebook 
		return Facebook.find(self.facebook_id)
	end
	def facebook_post_wall
		self.get_facebook.post_wall(self)
	end

	def self.make_gexf user_id
		users = User.find(:all, :order => "ancestry")
		puts users.inspect
		builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
			xml.gexf('xmlns:viz' => 'http:///www.gexf.net/1.1draft/viz', 'version' => '1.1', 'xmlns' => 'http://www.gexf.net/1.1draft') do
				xml.graph('defaultedgetype' => 'directed', 'idtype' => 'string', 'type' => 'static') do
					xml.attributes("class" => "node", "mode" => "static") do
						xml.attribute("id" => "sign", "title" => "Sign", "type" => "string")
					end
					xml.nodes do 
						users.each do |user|
							xml.node('id' => "#{user.id}", 'label' => "#{user.username}") do
								xml.attvalues do 
									if(user.id == user_id.to_i)
										xml.attvalue('for' => "sign","value" => "me")
									else
										xml.attvalue('for' => "sign","value" => "")
									end
								end
								xml['viz'].size('value' => Math.log2(user.node_cnt + 1))
								xml['viz'].color('r' => User.color_r(user.color), 'g' => User.color_g(user.color), 'b' => User.color_b(user.color))
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
		youruser = User.find(youruser_id)
		self.parent = youruser
		self.save
		n_cnt = self.node_cnt
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

	end

	def seize youruser_id
		youruser = User.find(youruser_id)
		youruser.parent = self
		youruser.save
		youruser.node_cnt

		self.node_cnt += youruser.node_cnt
		self.save!

		self.descendants.each do |descentdant|
			descentdant.color = self.color
			descentdant.save!
		end

	end

	def independance
		self.parent = nil
		self.color = "#{rand(256)}/#{rand(256)}/#{rand(256)}",
		self.save

		self.descendants.each do |descentdant|
			descentdant.color = self.color
			descentdant.save!
		end
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
=begin
<?xml version="1.0" encoding="UTF-8"?>
<gexf xmlns:viz="http:///www.gexf.net/1.1draft/viz" version="1.1" xmlns="http://www.gexf.net/1.1draft">
  <meta lastmodifieddate="2010-05-29+01:27">
  </meta>
  <graph defaultedgetype="directed" idtype="string" type="static">
    <nodes>
      <node id="0" label="Hello">
        <viz:size value="20.142857"/>
        <viz:color b="30" g="48" r="0"/>
      </node>
      <node id="1" label="Word111111111111111">
        <viz:size value="20.142857"/>
        <viz:color b="30" g="48" r="204" a="0.3"/>
      </node>
      <node id="2" label="Word">
        <viz:size value="20.142857"/>
        <viz:color b="30" g="48" r="204"/>
      </node>
      <node id="3" label="Word">
        <viz:size value="20.142857"/>
      </node>
    </nodes>
    <edges>
      <edge id="0" source="0" target="1"/>
      <edge id="1" source="2" target="1"/>
    </edges>
  </graph>
</gexf>
=end

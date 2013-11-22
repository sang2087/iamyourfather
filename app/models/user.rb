class User < ActiveRecord::Base
  attr_accessible :banner, :color, :facebook_uid, :ip, :point, :username, :ancestry, :node_cnt
	has_ancestry 
	def self.make_gexf
		users = User.all
		builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
			xml.gexf('xmlns:viz' => 'http:///www.gexf.net/1.1draft/viz', 'version' => '1.1', 'xmlns' => 'http://www.gexf.net/1.1draft') do
				xml.graph('defaultedgetype' => 'directed', 'idtype' => 'string', 'type' => 'static') do
					xml.nodes do 
						users.each do |user|
							xml.node('id' => "#{user.id}", 'label' => "#{user.username}") do
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
	end

	def seize youruser_id
		youruser = User.find(youruser_id)
		youruser.parent = self
		youruser.save
	end

	def independance
		self.parent = nil
		self.save
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

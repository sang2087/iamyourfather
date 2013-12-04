puts "start seed"
puts "base data start"
BaseData.create(:mytype => "PointLog",
								:code => 1,
								:point => 5,
								:description => "no facebook link in")

BaseData.create(:mytype => "PointLog",
								:code => 2,
								:point => 30,
								:description => "facebook link in")

BaseData.create(:mytype => "PointLog",
								:code => 3,
								:point => -100,
								:node_cnt => 10,
								:description => "independance")

BaseData.create(:mytype => "PointLog",
								:code => 4,
								:point => -10, #mulify your node_cnt
								:node_cnt => 5,
								:description => "betray")

BaseData.create(:mytype => "PointLog",
								:code => 5,
								:point => -30, #mulify your node_cnt
								:node_cnt => 15,
								:description => "seize")

BaseData.create(:mytype => "PointLog",
								:code => 6,
								:point => 10,
								:description => "invitation message")

BaseData.create(:mytype => "PointLog",
								:code => 7,
								:point => 10,
								:description => "login 10 min-term")

BaseData.create(:mytype => "PointLog",
								:code => 8,
								:point => 30,
								:description => "Share Feed")
puts "base data end"

ROOT_SIZE = 1
SIZE = 300

%w[Mercury Vinus Earth Mars Jupiter Saturn Uranus Neptune].each do |planet|
	User.create(:ip => "0.0.0.0",
							:username => planet,
							:point => 0,
							:color => "#{100 + rand(156)}/#{100 + rand(156)}/#{100 + rand(156)}",
							:banner => "Welcome to #{planet}",
							:node_cnt => 1)
end

=begin

1.upto(SIZE) do |i|
	User.create(:ip => "0.0.0.0",
							:username => "man #{i}",
							:point => 0,
							:banner => "#{i} node!!",
							:node_cnt => 1 )
end

(ROOT_SIZE + 1).upto(ROOT_SIZE + SIZE) do |i|
	r = rand(i) + 1
	user = User.find(i)
	if(i != r)
		user.parent = User.find(r)
		user.save!
		user.color = user.root.color
		user.save!
	else
		user.parent = User.find(rand(ROOT_SIZE) + 1)
		user.save!
		user.color = user.root.color
		user.save!
	end
end

puts "counting..."
User.all.each do |u|
	u.node_cnt = u.descendant_ids.count + 1
	u.save!
end
=end

User.all_tree_set_xy
puts "That's all!"


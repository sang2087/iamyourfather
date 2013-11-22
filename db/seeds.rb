puts "start seed"
ROOT_SIZE = 5
SIZE = 30
1.upto(ROOT_SIZE) do |i|
	User.create(:ip => "0.0.0.0",
							:username => "The God#{i}",
							:point => 0,
							:color => "#{rand(256)}/#{rand(256)}/#{rand(256)}",
							:banner => "I am the God#{i}",
							:node_cnt => 1)
end
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
puts "That's all!"

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


(ROOT_SIZE+1).upto(ROOT_SIZE + SIZE) do |i|
	begin
		r = rand(i) + 1
		if(i != r)
			user = User.find(i)
			user.parent = User.find(r)
			user.color = user.root.color
			user.save!
		end
	rescue
		puts "rescue"
		user = User.find(i)
		user.parent = User.find(rand(ROOT_SIZE) + 1)
		user.color = user.root.color
		user.save!
	end
end
puts "counting..."
User.all.each do |u|
	u.node_cnt = u.descendant_ids.count + 1
	u.save
end
puts "That's all!"

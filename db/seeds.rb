puts "start seed"
1.upto(10) do |i|
	User.create(:ip => "0.0.0.0",
							:username => "The God#{i}",
							:point => 0,
							:color => "#{rand(256)}/#{rand(256)}/#{rand(256)}",
							:banner => "I am the God#{i}",
							:node_cnt => 1)
end
1.upto(1000) do |i|
	User.create(:ip => "0.0.0.0",
							:username => "man #{i}",
							:point => 0,
							:banner => "#{i} node!!",
							:node_cnt => 1 )
end


11.upto(1010) do |i|
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
		user.parent = User.find(rand(10) + 1)
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

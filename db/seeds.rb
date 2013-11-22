puts "start seed"
User.create(:ip => "0.0.0.0",
						:username => "The God",
						:point => 0,
						:color => "255/255/255",
						:banner => "I am the God",
						:node_cnt => 1)
0.upto(30) do |i|
	User.create(:ip => "0.0.0.0",
							:username => "The God#{i}",
							:point => 0,
							:color => "#{rand(255)}/#{rand(255)}/#{rand(255)}",
							:banner => "I#{i}od",
							:node_cnt => rand(10)+1 )
end


2.upto(30) do |i|
	begin
		r = rand(i)+1
		if(i != r)
			user = User.find(i)
			user.parent = User.find(r)
			user.color = user.root.color
			user.save!
		end
	rescue
		puts "rescue"
		user = User.find(i)
		user.parent = User.find(1)
		user.color = user.root.color
		user.save!
	end
end


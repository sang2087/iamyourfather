class PointLog < ActiveRecord::Base
  attr_accessible :point, :type, :user_id, :your_id
	belongs_to :user
	def self.link_in_without_fb user, your_id
		code = 1
		bd = BaseData.where(:type => "PointLog", :code => code).first
		edit_point(user, your_id, code, bd.point)

	end

	def self.link_in_with_fb user, your_id
		code = 2
		bd = BaseData.where(:type => "PointLog", :code => code).first
		edit_point(user, your_id, code, bd.point)
	end

	def self.independance user, your_id
		code = 3
		bd = BaseData.where(:type => "PointLog", :code => code).first
		if (user.point + bd.point > 0 and user.node_cnt > bd.node_cnt)
			edit_point(user, your_id, code, bd.point)
		else
			return false
		end
	end
	
	def self.betray user, your_id
		code = 4
		bd = BaseData.where(:type => "PointLog", :code => code).first
		if (user.point + (bd.point * user.node_cnt) > 0 and user.node_cnt > bd.node_cnt)
			edit_point(user, your_id, code, bd.point)
		else
			return false
		end
	end
	
	def self.seize user, your_id

		code = 5
		bd = BaseData.where(:type => "PointLog", :code => code).first
		if (user.point + (bd.point * user.node_cnt) > 0 and user.node_cnt > bd.node_cnt)
			edit_point(user, your_id, code, bd.point)
		else
			return false
		end
	end
	
	def self.invitation user, your_id
		code = 6
		bd = BaseData.where(:type => "PointLog", :code => code).first
		edit_point(user, your_id, code, bd.point)

	end

	def self.login user
		code = 7
		bd = BaseData.where(:type => "PointLog", :code => code).first

		PointLog.edit_points(user, user.id, code, bd.point)

	end

	def self.edit_points user, your_id, code, point
		pl = user.point_logs.new
		pl.type = code
		pl.user_id = user.id
		pl.your_id = your_id
		pl.point = point

		user.point += point

		ret = ActiveRecord::Base.transaction do
			pl.save!
			user.save!
		end

		ret
	end
	def self.is_function_possible? user, code
		puts "function CODE#{code.to_i}"
		bd = BaseData.where(:type => "PointLog", :code => code).first
		
		ret = false
		case code.to_i
		when 3
			if (user.point + bd.point > 0 and user.node_cnt > bd.node_cnt)
				ret = true
			end
		when 4
			if (user.point + (bd.point * user.node_cnt) > 0 and user.node_cnt > bd.node_cnt)
				ret = true
			end
		when 5
			if (user.point + (bd.point * user.node_cnt) > 0 and user.node_cnt > bd.node_cnt)
				ret = true
			end
		end

		ret
	end



end

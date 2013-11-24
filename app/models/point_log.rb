class PointLog < ActiveRecord::Base
  attr_accessible :point, :type, :user_id, :your_id
	belongs_to :user

	def self.link_without_fb user
		code = 1
		parent_id = user.parent_id
		unless parent_id.nil?
			bd = BaseData.where(:type => "PointLog", :code => code).first
			PointLog.change_point(user, user.parent_id, code, bd.point)
		end
	end

	def self.link_with_fb user
		code = 2
		parent_id = user.parent_id
		unless parent_id.nil?
			bd = BaseData.where(:type => "PointLog", :code => code).first
			PointLog.change_point(user, user.parent_id, code, bd.point)
		end
	end

	def self.independance user
		code = 3
		ret, limit_point, limit_node_cnt = PointLog.is_function_possible?(user, nil, code)
		if ret
			puts "limit #{ret}"
			puts "limit #{limit_point}"
			puts "limit #{limit_node_cnt}"
			PointLog.change_point(user, 0, code, limit_point)
		else
			return false
		end
	end
	
	def self.betray user, your
		code = 4
		ret, limit_point, limit_node_cnt = PointLog.is_function_possible?(user, your, code)
		if ret
			PointLog.change_point(user, your.id, code, limit_point)
		else
			return false
		end

	end
	
	def self.seize user, your

		code = 5
		ret, limit_point, limit_node_cnt = PointLog.is_function_possible?(user, your, code)
		if ret
			PointLog.change_point(user, your.id, code, limit_point)
		else
			return false
		end
	end
	
	def self.invitation user, your
		code = 6
		bd = BaseData.where(:type => "PointLog", :code => code).first
		PointLog.change_point(user, your.id, code, bd.point)

	end

	def self.login user
		code = 7
		bd = BaseData.where(:type => "PointLog", :code => code).first

		PointLog.change_point(user, user.id, code, bd.point)

	end
	def self.post_wall user
		code = 8
		bd = BaseData.where(:type => "PointLog", :code => code).first
		PointLog.change_point(user, your.id, code, bd.point)
	end

	def self.change_point user, your_id, code, point
		puts "point #{user} #{your_id} #{code} #{point}!"
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
	def self.is_function_possible? user, your, code
		code = code.to_i
		puts "function CODE#{code.to_i}"
		bd = BaseData.where(:type => "PointLog", :code => code).first
		
		ret = false
		case code
		when 3
			if(user.point + PointLog.deduct_point(code, nil) > 0 and user.node_cnt > bd.node_cnt)
				ret = true
			end
			limit_point = bd.point
			limit_node_cnt = bd.node_cnt
		when 4
			if (user.point + PointLog.deduct_point(code, your.node_cnt) > 0 and user.node_cnt > bd.node_cnt)
				ret = true
			end
			limit_point = (bd.point * your.node_cnt)
			limit_node_cnt = bd.node_cnt
		when 5
			if (user.point + PointLog.deduct_point(code, your.node_cnt) > 0 and user.node_cnt > bd.node_cnt)
				ret = true
			end
			limit_point = (bd.point * your.node_cnt)
			limit_node_cnt = bd.node_cnt
		end
		puts "point!#{limit_point}"

		[ret, limit_point, limit_node_cnt]

	end
	def PointLog.deduct_point(code, node_cnt)
		ret_point = 0

		bd = BaseData.where(:type => "PointLog", :code => code).first
		case code.to_i
		when 3
			ret_point = bd.point
		when 4
			ret_point = (bd.point * node_cnt)
		when 5
			ret_point = (bd.point * node_cnt)
		end
	end

end

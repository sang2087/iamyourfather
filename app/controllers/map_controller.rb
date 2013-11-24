class MapController < ApplicationController
  def index
		puts "@user map #{@user}"
		name = params[:id] || "1" # 1 is the God
		# need facebook login check
		father = User.find(name)


		if session[:user_id].nil? # session(cookie) check
			newbie = User.new(:ip => request.remote_addr,
												:username => "Baby", # need to random in sample
												:point => 0,
												:color => father.color,
												:banner => "Hello, World!",
												:node_cnt => 1) # need to random in sample
			newbie.parent = father
			if newbie.save
				session[:user_id] = newbie.id
				newbie.username = "Baby-#{newbie.id}"
				newbie.save!
				newbie.ancestors.each do |a|
					a.node_cnt += 1
					a.save
				end
			end

			@user = newbie
		end

		@user_id = session[:user_id]
		@groups = User.get_groups || "null"

		#this is Login Point

		@is_point_get_login = session[:login_point]
		puts "@is_point_get_login #{@is_point_get_login}"
		session[:login_point] = false
		@login_point = BaseData.where(:type=>"PointLog", :code=>7).first.point

  end

	def independance
		@user.independance

		render :text => "success"
  end

  def seize
		@user.seize params[:user_id]

		render :text => "success"
  end

	def betray
		@user.betray params[:user_id]

		render :text => "success"
  end

end

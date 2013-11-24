class MapController < ApplicationController
  def index
		name = params[:id] || "1" # 1 is the God
		# need facebook login check
		father = User.find(name)
		if session[:user_id].nil? # session(cookie) check
			newbie = User.new(:ip => request.remote_addr,
												:username => "Baby", # need to random in sample
												:point => 0,
												:color => "ff/00/00", # need to random in sample
												:banner => "Hello, World!",
												:node_cnt => 1) # need to random in sample
			newbie.parent = father
			if newbie.save
				session[:user_id] = newbie.id
				newbie.ancestors.each do |a|
					a.node_cnt += 1
					a.save
				end
			end
		end
		user = User.find(session[:user_id])
		@user = user
		@user_id = session[:user_id]
		@groups = User.get_groups || "null"
		# return gexf
  end

	def independance
		user = User.find(session[:user_id])
		user.independance

		render :text => "success"
  end

  def seize
		user = User.find(session[:user_id])
		user.seize params[:user_id]

		render :text => "success"
  end

	def betray
		user = User.find(session[:user_id])
		user.betray params[:user_id]

		render :text => "success"
  end

end

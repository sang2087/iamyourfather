class MapController < ApplicationController
  def index
		session[:user_id] = 10
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
		@user_id = session[:user_id]
		@groups = User.get_groups || "null"
		# return gexf
  end

	def data
		data = User.make_gexf
		render :xml => data 
	end

  def seize
  end

  def independence
  end

  def betray
  end

	def session_destory
		session[:user_id] = nil
	end
	def get_user
		if(params[:user_id] == "0")
			user = User.find(session[:user_id])
		else
			user = User.find(params[:user_id])
		end
		render :json => user 
	end
end

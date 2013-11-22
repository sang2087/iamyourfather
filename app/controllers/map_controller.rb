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
		@user_id = session[:user_id]
		# return gexf
  end

	def data
		data = { :sample => "test" }
		respond_to do |format|
			format.gexf { render :gexf => data }
		end
	end

  def seize
  end

  def independence
  end

  def betray
  end
end

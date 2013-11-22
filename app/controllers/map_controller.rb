class MapController < ApplicationController
  def index
		name = params[:id] || "1" # 1 is the God
		# need facebook login check
		father = User.find(name)
		if session[:user_id].nil? # session(cookie) check
			newbie = User.create(:ip => request.remote_addr,
												 :username => "Baby", # need to random in sample
												 :point => 0,
												 :color => "ff/00/00", # need to random in sample
												 :banner => "Hello, World!") # need to random in sample
			newbie.parent = father
			if newbie.save
				session[:user_id] = newbie.id
			end
		end
		@user_id = session[:user_id]
		# return gexf
  end

	def data
		data = User.make_gexf
		puts data

		render :xml => data 
	end

  def seize
  end

  def independence
  end

  def betray
  end
end

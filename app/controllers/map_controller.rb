class MapController < ApplicationController
  def index
		@name = params[:id]
		# ipcheck
		# cookie check
		# facebook login check
		#
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

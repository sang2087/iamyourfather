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

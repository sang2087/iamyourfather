#encoding : utf-8
class MapController < ApplicationController
  def index
		puts "@user map #{@user}"
		name = params[:id] || (rand(User.count) + 1).to_s # 1 is the God
		# need facebook login check
		
		father = User.find(name)

		@is_session_user = session[:user_id]
		if session[:user_id].nil? # session(cookie) check
			newbie = User.new(#:ip => request.remote_addr,
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

				User.set_tree_xy newbie.root 
			end

			newbie.link_in 
			@user = newbie
		end
		@ancestors = @user.ancestor_ids
		@descendants = @user.descendant_ids
		
		@father = @user.parent
		@founder = @user.root
		puts "i18n!#{I18n.locale}!"
		if I18n.locale.to_s == 'ko'
			@founder_depth = "#{@user.depth}대손"
		else
			@founder_depth = @user.depth.ordinalize
		end

		if @father.nil?
			@is_father = false
			@father=@user
			@founder=@user
		else
			@is_father = true
		end

		@groups = User.get_groups || "null"

		#this is Login Point

		@is_point_get_login = session[:login_point]
		puts "@is_point_get_login #{@is_point_get_login}"
		session[:login_point] = false
		@login_point = BaseData.where(:mytype=>"PointLog", :code=>7).first.point
		@node_cnt_rank = @user.my_rank "node_cnt"
		@point_rank = @user.my_rank "point"
		@all_rank_node_cnt = User.all_rank "node_cnt"
		@all_rank_point = User.all_rank "point"

  end

	def independance
		@user.independance

		render :text => "success"
  end

  def seize
		@user.seize(params[:user_id])

		render :text => "success"
  end

	def betray
		@user.betray params[:user_id]

		render :text => "success"
  end

end

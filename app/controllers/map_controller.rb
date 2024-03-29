#encoding : utf-8
class MapController < ApplicationController
  def index
#@is_session_user = session[:user_id]
		@is_session_user = nil
		if(params[:id] == 'likelion_root')
			user = User.create(:ip => "0.0.0.0",
						:username => "root",
						:point => 0,
						:color => "#{100 + rand(156)}/#{100 + rand(156)}/#{100 + rand(156)}",
						:banner => "root",
						:node_cnt => 1)
			session[:user_id] = user.id
			user.rand_display_xy

			@user = user
		else
			puts "@user map #{@user}"
			enter_id = params[:id] || (rand(User.count) + 1).to_s # 1 is the God
			# need facebook login check
			
			father = User.find(enter_id)

			if session[:user_id].nil? or User.find(session[:user_id]).nil? # session(cookie) check
				newbie = User.new(#:ip => request.remote_addr,
													:username => "Baby", # need to random in sample
													:point => 0,
													:color => father.color,
													:banner => "Hello",
													:node_cnt => 1) # need to random in sample
				newbie.parent = father
				if newbie.save
					session[:user_id] = newbie.id
					newbie.username = "Baby-#{newbie.id}"
					newbie.banner = "Baby-#{newbie.id}"
					newbie.save!
					newbie.ancestors.each do |a|
						a.node_cnt += 1
						a.point += 5
						a.save
					end
					newbie_root = newbie.root
					cl = User.children_list(newbie_root)

					#User.set_tree_xy newbie_root, cl, 'all'
					#User.set_tree_xy newbie_root, cl, 'family'
				end

				newbie.link_in 
				@user = newbie
			end
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
		users=User.all
		@node_cnt_rank = @user.my_rank users, "node_cnt"
		@point_rank = @user.my_rank users, "point"
		user=user
		@all_rank_node_cnt = User.all_rank users, "node_cnt"
		@all_rank_point = User.all_rank users, "point"
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

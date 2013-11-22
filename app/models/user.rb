class User < ActiveRecord::Base
  attr_accessible :banner, :color, :facebook_uid, :ip, :point, :username, :ancestry, :node_cnt
	has_ancestry
end

class User < ActiveRecord::Base
  attr_accessible :banner, :color, :facebook_uid, :ip, :point, :username, :ancestry
	has_ancestry
end

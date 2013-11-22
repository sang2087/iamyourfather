class User < ActiveRecord::Base
  attr_accessible :banner, :color, :facebook_uid, :ip, :point, :username
end

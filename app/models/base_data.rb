class BaseData < ActiveRecord::Base
  attr_accessible :type, :code, :point, :node_cnt, :description
end

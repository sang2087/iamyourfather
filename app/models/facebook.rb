class Facebook < ActiveRecord::Base
  attr_accessible :first_name, :gender, :last_name, :link, :locale, :middle_name, :name, :uid, :username
end

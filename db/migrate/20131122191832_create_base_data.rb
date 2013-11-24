class CreateBaseData < ActiveRecord::Migration
  def change
    create_table :base_data do |t|
			t.string	:mytype,		:null => false
			t.integer	:code,		:default => 0
			t.integer	:point,		:default => 0 
			t.integer	:node_cnt,		:default => 0 #have to more than node_cnt
			t.string	:description, :default => ""


      t.timestamps
    end
  end
end

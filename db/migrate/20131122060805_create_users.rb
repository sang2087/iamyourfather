class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :ip,							:defalut => "0.0.0.0"
      t.string :facebook_uid
      t.string :username,				:default => "baby"
      t.integer :point,					:default => 0
      t.string :color,					:default => "ff/ff/ff"
      t.string :banner,					:default => "hello world"
			t.integer :node_cnt,			:default => 1

      t.timestamps
    end
  end
end

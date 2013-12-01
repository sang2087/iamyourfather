class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :ip,							:defalut => "0.0.0.0"
      t.string :facebook_uid
			t.integer :facebook_id
      t.string :username,				:default => "baby"
      t.string :picture,				:default => "/img/nopicture.jpg"
      t.integer :point,					:default => 0
      t.string :color,					:default => "255/255/255"
      t.string :banner,					:default => "hello world"
			t.integer :node_cnt,			:default => 1

			t.float :displayX,			:default => 0
			t.float :displayY,			:default => 0
			t.float :cx,						:default => 0
			t.float :cy,						:default => 0
			t.float :fx,						:default => 0
			t.float :fy,						:default => 0


      t.timestamps
    end
  end
end

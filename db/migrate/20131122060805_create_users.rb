class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :ip
      t.string :facebook_uid
      t.string :username
      t.integer :point
      t.string :color
      t.string :banner

      t.timestamps
    end
  end
end

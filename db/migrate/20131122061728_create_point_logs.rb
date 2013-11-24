class CreatePointLogs < ActiveRecord::Migration
  def change
    create_table :point_logs do |t|
      t.integer :user_id
      t.integer :your_id
      t.string  :mytype
      t.integer :code
      t.integer :point

      t.timestamps
    end
  end
end

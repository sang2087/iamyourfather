class AddAncestryToUser < ActiveRecord::Migration
  def change
    add_column :users, :ancestry, :string
  end

	def up
		add_index :users, :ancestry
	end

	def down
		remove_index :users, :ancestry
end

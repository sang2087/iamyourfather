class CreateFacebooks < ActiveRecord::Migration
  def change
    create_table :facebooks do |t|
      t.string :uid
      t.string :name
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :link
      t.string :username
      t.string :gender
      t.string :locale

      t.timestamps
    end
  end
end

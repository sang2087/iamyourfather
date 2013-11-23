class CreateFacebooks < ActiveRecord::Migration
  def change
    create_table :facebooks do |t|
      t.string :uid
			t.string :user_id
      t.string :name
      t.string :gender
      t.string :locale
			t.string :oauth_token
			t.string :oauth_expires_at

      t.timestamps
    end
  end
end

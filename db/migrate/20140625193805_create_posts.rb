class CreatePosts < ActiveRecord::Migration
  def change
  	create_table :posts do |t|
  		t.datetime :date
  		t.string :user
  		t.string :title
  		t.string :body
  	end
  end
end

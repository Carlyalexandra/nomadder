class ChangeUserOnPosts < ActiveRecord::Migration
  def change 
  	rename_column(:posts, :user, :user_id)
  end
end

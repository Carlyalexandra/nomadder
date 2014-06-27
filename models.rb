class User < ActiveRecord::Base
	has_many :posts, :dependent => :destroy
	has_many :relationships, :foreign_key => "follower_id",
			 :dependent => :destroy

	
	has_many :reverse_relationships, :foreign_key => "followed_id",
			 :class_name => "Relationship",
			 :dependent => :destroy

	has_many :following, :through => :relationships, :source => :followed

	def following?(followed)
		relationships.find_by_followed_id(followed)
	end

	def follow!(followed)
		relationships.create!(:followed_id => followed.id)
	end

	def unfollow!(followed)
		relationships.find_by_followed_id(followed).destroy
	end
end

class Post < ActiveRecord::Base
	belongs_to :user
	validates_length_of :body, :maximum=>150
end

class Relationship < ActiveRecord::Base
	# attr_accessible :followed_id

	belongs_to :follower, :class_name => "User"
	belongs_to :followed, :class_name => "User"

	validates :follower_id, :presence => true
	validates :followed_id, :presence => true
end
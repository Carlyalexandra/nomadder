class User < ActiveRecord::Base
	has_many :posts
end

class Post < ActiveRecord::Base
	belongs_to :user
	validates_length_of :body, :maximum=>150
end

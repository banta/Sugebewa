class Micropost < ActiveRecord::Base
  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 150 }
  validates :user_id, :presence => true
  validates :content, :presence => true

  def self.from_users_followed_by(user)
    followed_ids = user.following.map(&:id).join(", ")
    where("user_id IN (#{followed_ids}) OR user_id = ?", user).order('updated_at desc')
  end
end

# POST /microposts
# POST /microposts.xml
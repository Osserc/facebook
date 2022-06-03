class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :email, :password, presence: true

  has_many :posts, foreign_key: "author_id", dependent: :destroy
  has_many :comments, foreign_key: "author_id", dependent: :destroy
  has_many :likes
  has_one :profile

  has_many :sent_requests, class_name: "FriendRequest", foreign_key: :sender_id
  has_many :friendees, through: :sent_requests, source: :receiver

  has_many :received_requests, class_name: "FriendRequest", foreign_key: :receiver_id
  has_many :wannabe_friends, through: :received_requests, source: :sender

  has_many :initiated_friendships, class_name: "Friendship", foreign_key: :friend_one_id
  has_many :befriendeds, through: :initiated_friendships, source: :friend_two

  has_many :received_friendships, class_name: "Friendship", foreign_key: :friend_two_id
  has_many :befriended_bys, through: :received_friendships, source: :friend_one

  has_many :followed_people, class_name: "Following", foreign_key: :follower_id
  has_many :follows, through: :followed_people, source: :follow

  has_many :following_people, class_name: "Following", foreign_key: :follow_id
  has_many :followers, through: :following_people, source: :follower

  has_many :blocked_people, class_name: "Blocking", foreign_key: :blocker_id
  has_many :blockeds, through: :blocked_people, source: :blocked

  has_many :blocked_by, class_name: "Blocking", foreign_key: :blocked_id
  has_many :blockers, through: :blocked_by, source: :blocker

  has_many :notifications, foreign_key: :receiver_id
  has_many :issued_notifications, class_name: "Notification", foreign_key: :issuer_id

  def friends
    self.befriendeds + self.befriended_bys
  end

  def friendships
    self.initiated_friendships + self.received_friendships
  end

  def requests
    self.sent_requests + self.received_requests
  end

end
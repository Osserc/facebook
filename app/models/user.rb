class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]

  validates :first_name, :last_name, :email, :password, presence: true

  after_create :create_profile, :send_welcome_email

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

  def name
    self.first_name + " " + self.last_name
  end

  def create_profile
    require "open-uri"
    if !Profile.exists?(user: self)
      default_avatars = Array.new
      default_avatars << "https://res.cloudinary.com/dkanag99x/image/upload/v1655047622/projects/facebook/default_avatar_1.png"
      default_avatars << "https://res.cloudinary.com/dkanag99x/image/upload/v1655231435/projects/facebook/default_avatar_2.jpg"
      default_avatars << "https://res.cloudinary.com/dkanag99x/image/upload/v1655231440/projects/facebook/default_avatar_3.jpg"
      self.build_profile
      self.profile.save
      avatar = default_avatars.sample
      self.profile.avatar.attach(io: URI.open(avatar), filename: avatar.sub(/.*?facebook/, '')[1..-1])
    end
  end

  def send_welcome_email
    UserMailer.with(user: self.id).welcome_email.deliver_later
  end

  def friends
    self.befriendeds + self.befriended_bys
  end

  def friendships
    self.initiated_friendships + self.received_friendships
  end

  def requests
    self.sent_requests + self.received_requests
  end

  def recommend_friends
    friends_all = self.friends.collect { | friend | friend.friends }.flatten.delete_if { | friend | self.friends.include?(friend) || self.blockeds.include?(friend) || self.blockers.include?(friend) }
    connections = friends_all.reduce(Hash.new(0)) do | friend, count |
      friend[count] += 1
      friend
    end
    recommends = connections.sort_by { | key, value | value }.reverse.first(3).collect { | connection | connection.first }
  end

  def recommend_follows
    (User.all - [self] - self.blockeds - self.blockers - self.follows).sort_by { | user | -user.followers.count }.first(5).sample(3)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
    end
  end

end
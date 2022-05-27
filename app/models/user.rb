class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :email, :password, presence: true

  has_many :posts, foreign_key: "author_id"
  has_many :comments, foreign_key: "author_id"
  has_many :likes

  has_many :sent_requests, class_name: "FriendRequest", foreign_key: :sender_id
  has_many :friendees, through: :sent_requests, source: :receiver

  has_many :received_requests, class_name: "FriendRequest", foreign_key: :receiver_id
  has_many :wannabe_friends, through: :received_requests, source: :sender

end
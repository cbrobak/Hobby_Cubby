class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :friendships
  has_many :friends, -> { where friendships: { status: :accepted }}, through: :friendships
  has_many :requested_friends, -> { where friendships: { status: :requested }}, through: :friendships, source: :friend
  has_many :pending_friends, -> { where friendships: { status: :pending }}, through: :friendships, source: :friend
  has_many :blocked_friends, -> { where friendships: { status: :blocked }}, through: :friendships, source: :friend

  def friend_request(friend)
    unless self == friend || Friendship.where(user: self, friend: friend).exists?
      transaction do
        Friendship.create(user: self, friend: friend, status: :pending)
        Friendship.create(user: friend, friend: self, status: :requested)
      end
    end
  end

  def accept_request(friend)
    transaction do
      Friendship.find_by(user: self, friend: friend, status: [:requested])&.accepted!
      Friendship.find_by(user: friend, friend: self, status: [:pending])&.accepted!
    end
  end
end

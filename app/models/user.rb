class User < ApplicationRecord
  validates_presence_of :first_name, :last_name
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, 
         jwt_revocation_strategy: self
  has_many :tweets
  has_many :follows

  def generate_jwt
    JWT.encode({ id: id,
                exp: 60.days.from_now.to_i },
               Rails.application.secrets.secret_key_base)
  end

  has_many :follower_relationships, foreign_key: :following_id, class_name: "Follow"
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :following_relationships, foreign_key: :user_id, class_name: "Follow"
  has_many :following, through: :following_relationships, source: :following

  def full_name
    "#{first_name} #{last_name}"
  end

end

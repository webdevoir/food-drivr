class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  before_create :generate_authentication_token!
  validates :auth_token, uniqueness: true

  # has_one :settings

  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_many :donations, foreign_key: "donor_id", class_name: "Donation"

  # Has many pickups and dropoffs through donations,
  # i.e. if they are a driver, they can have many pickups and dropoffs

  has_many :pickups, through: :donations
  has_many :dropoffs, through: :donations

  # User should have a role_id, although we may want to look into setting
  # Up seperate classes.
  belongs_to :role

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

end

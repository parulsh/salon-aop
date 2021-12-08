class User < ApplicationRecord
  has_secure_password

  enum role: { customer: 0, owner: 1 }

  has_many :salons, dependent: :destroy
  has_many :bookings, dependent: :destroy
  
  validates :role, inclusion: { in: User.roles.keys }
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  def owner?
    role == 'owner'
  end

  def customer?
    role == 'customer'
  end
end

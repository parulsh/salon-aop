class Service < ApplicationRecord
  belongs_to :salon
  has_many :bookings, dependent: :destroy
end

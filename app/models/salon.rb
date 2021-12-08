class Salon < ApplicationRecord
  has_many :services, dependent: :destroy
  belongs_to :user

  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :end_time_is_greater_than_start_time

  private
    def end_time_is_greater_than_start_time
      if end_time <= start_time
        errors.add(:end_time, "can not be less than or equal to start_time ") 
      end
    end
end

class Booking < ApplicationRecord
  include TimeSlots

  belongs_to :user
  belongs_to :service

  validate :time_slot_is_valid

  private
    def time_slot_is_valid
      salon = self.service.salon
      @output = available_slots(salon)
      choosen_slot = self.time_slot_taken
      if choosen_slot.strftime('%H:%M').in?(@output) == false
        return errors.add(:time_slot_taken, "is not available")
      end
      in_between_slots_also_available
    end

    def in_between_slots_also_available
      booking_slot = []
      choosen_slot = self.time_slot_taken
      duration_in_hour = self.service.duration.strftime("%H").to_i.hour
      duration_in_minute = self.service.duration.strftime("%M").to_i.minute
      ending_time = ((choosen_slot + duration_in_hour + duration_in_minute).ceil_to(60*30) - 30.minutes).strftime('%H:%M')
      booking_slot << choosen_slot.strftime('%H:%M')
      while booking_slot.last < ending_time
        booking_slot << (booking_slot.last.to_time + 30.minutes).strftime('%H:%M')
      end
      unless (booking_slot - @output).empty?
        errors.add(:time_slot_taken, "is not available because in between time is taken by other customer")
      end
    end
end

module TimeSlots
  def available_slots(salon)
    initialize_required_values(salon)
    total_slots
    booked_slots
    @total_time_slots.each do |time|
      count = @booked_time_slots.count(time)
      @available_time_slots << time if count < @chairs
    end
    @available_time_slots
  end

  def initialize_required_values(salon)
    salon_bookings = salon.services.collect(&:bookings).flatten
    @todays_bookings = Booking.where(id: salon_bookings.pluck(:id)).where('DATE(created_at) = ?',Date.today)
    @current_time = Time.now.ceil_to(60*30).strftime('%H:%M')
    @start_time = salon.start_time.ceil_to(60*30).strftime('%H:%M')
    @end_time = salon.end_time.floor_to(60*30).strftime('%H:%M')
    @chairs = salon.total_chairs
    @total_time_slots = []
    @booked_time_slots = []
    @available_time_slots = []
  end

  def total_slots
    if @current_time <= @start_time
      @total_time_slots << @start_time
      while @total_time_slots.last < @end_time
        @total_time_slots << (@total_time_slots.last.to_time + 30.minutes).strftime('%H:%M')
      end
    elsif @current_time > @start_time && @current_time < @end_time
      @total_time_slots << @current_time
      while @total_time_slots.last < @end_time
        @total_time_slots << (@total_time_slots.last.to_time + 30.minutes).strftime('%H:%M')
      end
    end
  end

  def booked_slots
    @todays_bookings.each do |booking|
      start_time_of_booking = booking.time_slot_taken
      duration_in_hour = booking.service.duration.strftime("%H").to_i.hour
      duration_in_minute = booking.service.duration.strftime("%M").to_i.minute
      end_time_of_booking = (start_time_of_booking + duration_in_hour + duration_in_minute).ceil_to(60*30) - 30.minutes
      @booked_time_slots << start_time_of_booking.strftime('%H:%M')
      while @booked_time_slots.last < end_time_of_booking.strftime('%H:%M')
        @booked_time_slots << (@booked_time_slots.last.to_time + 30.minutes).strftime('%H:%M')
      end
    end
  end
end

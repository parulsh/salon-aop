class BookingsController < ApplicationController
  before_action :authorize_request
  before_action :find_booking, only: [:show, :update, :destroy]

  def index
    @bookings = current_user.bookings
    render json: @bookings, status: :ok
  end

  def show
    render json: @booking, status: :ok
  end

  def create
    @booking = Booking.new(booking_params.merge(user_id: current_user.id))
    if @booking.save
      render json: @booking, status: :created
    else
      render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @booking.update(booking_params)
      render json: @booking, status: :ok
    else
      render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy
    render json: {message: "Booking successfully deleted"}, status: :ok
  end

  private
    def booking_params
      params.permit(:user_id, :service_id, :time_slot_taken)
    end

    def find_booking
      @booking = current_user.bookings.find_by(id: params[:id])
      return render json: { error: {message: 'Booking does not exist'} }, status: :unprocessable_entity if @booking.nil?
    end
end

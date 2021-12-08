class SalonsController < ApplicationController
  include TimeSlots
  
  before_action :authorize_request
  load_and_authorize_resource except: [:available_time_slots]
  
  before_action :find_salon, except: [:index, :create]
  before_action :validate_salon_owner, only: [:destroy, :update]

  def index
    @salons = Salon.all
    render json: @salons, status: :ok
  end

  def show
    render json: @salon, status: :ok
  end

  def create
    @salon = Salon.new(salon_params.merge(user_id: current_user.id))
    if @salon.save
      render json: @salon, status: :created
    else
      render json: { errors: @salon.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @salon.update(salon_params)
      render json: @salon, status: :ok
    else
      render json: { errors: @salon.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @salon.destroy
    render json: {message: "Salon successfully deleted"}, status: :ok
  end

  def available_time_slots
    @available_slots = available_slots(@salon)
    render json: @available_slots, status: :ok
  end

  private
    def salon_params
      params.permit(:company_name, :gstin, :pan_number, :user_id, :address, :start_time, :end_time, :total_chairs)
    end

    def find_salon
      @salon = Salon.find_by(id: params[:id])
      # return render json: { error: {message: 'Salon does not exist'} }, status: :unprocessable_entity if @salon.nil?
    end

    def validate_salon_owner
      return render json: { error: {message: 'You can not update or destroy other owners salons'} }, status: :unprocessable_entity if current_user.id != @salon.user_id
    end
end

class ServicesController < ApplicationController
  before_action :authorize_request
  load_and_authorize_resource
  
  before_action :find_salon
  before_action :find_salon_service, only: [:update, :destroy] 
  before_action :validate_service_belongs_to_owner, only: [:update, :create, :destroy]

  def index
    @services = @salon.services
    render json: @services, status: :ok
  end

  def create
    @service = @salon.services.new(service_params)
    if @service.save
      render json: @service, status: :created
    else
      render json: { errors: @service.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @service.update(service_params)
      render json: @service, status: :ok
    else
      render json: { errors: @service.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @service.destroy
    render json: {message: "Service successfully deleted"}, status: :ok
  end

  private
    def service_params
      params.permit(:title, :salon_id, :duration, :price)
    end

    def find_salon
      @salon = Salon.find_by(id: params[:salon_id])
      return render json: { error: {message: 'Salon does not exist'} }, status: :unprocessable_entity if @salon.nil?
    end

    def find_salon_service
      @service = @salon.services.find_by(id: params[:id])
      return render json: { error: {message: 'Service does not exist'} }, status: :unprocessable_entity if @service.nil?
    end

    def validate_service_belongs_to_owner
      return render json: { error: {message: 'You can not create, update or destroy services of other owners salons'} }, status: :unprocessable_entity if current_user.id != @salon.user_id
    end
end

class UsersController < ApplicationController
  before_action :authorize_request, except: :create

  def show
    @user =  current_user
    render json: @user, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @user = current_user
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    render json: {message: "User successfully deleted"}, status: :ok
  end

  private
    def user_params
      params.permit(:name, :username, :email, :password, :password_confirmation, :role)
    end
end

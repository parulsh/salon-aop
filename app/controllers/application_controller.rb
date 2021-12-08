class ApplicationController < ActionController::API
  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    header = request.headers['token']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  rescue_from CanCan::AccessDenied do |e|
    render json: { error: {message: "Access denied! You must be an owner to access these features"} }
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: {message: e.message } }
  end
end

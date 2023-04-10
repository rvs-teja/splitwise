class ApplicationController < ActionController::API

  before_action :authenticate_user!

  rescue_from AuthenticationError, with: :authentication_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private
  def authenticate_user!
    return true if skip_authentication?

    token = request.headers['Authorization']

    user = AuthenticationManager.new(token)
    user.verify
  end

  def skip_authentication?
    params[:query].include?('login')
  end

  def current_user
    Current.user
  end

  def authentication_error(exception)
    render json: { errors: { code: exception.code, message: exception.message } }
  end

  def record_not_found(exception)
    render json: { errors: { message: exception.message } }
  end

  def record_invalid(exception)
    render json: { errors: { message: exception.message } }
  end


end

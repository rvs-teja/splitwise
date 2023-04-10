class AuthenticationManager

  attr_accessor :token

  def initialize(token)
    @token = token
  end

  def verify
    missing_token if token.blank?
    params = token_params
    user = fetch_user(params[:user_id])
    invalid_token unless user

    current_user(user)
    true
  end

  private

  def fetch_user(id)
    User.find_by(id: id)
  end

  def token_params
    token = parse_token
    params = JsonWebToken.decode(token)
    invalid_token if params.empty?

    {
      exp: params[:exp],
      user_id: params[:user_id]
    }
  end

  def parse_token
    token.split(' ').last
  end

  def current_user(user)
    Current.user = user
  end

  def raise_error(msg, code)
    raise AuthenticationError.new(msg, code: code)
  end

  def invalid_token
    raise_error('Invalid token!', 'TOKEN_INVALID')
  end

  def missing_token
    raise_error('Missing token!', 'TOKEN_MISSING')
  end

end

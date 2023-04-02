class AuthenticationManager
  attr_accessor :user

  def initialize(user_name:)
    @user = fetch_user(user_name)
  end

  def login(password)
    unless valid_password?(password)
      raise AuthenticationError.new('Enter a valid password', code: 'AUTHENTICATION_ERROR', parameter: 'password')
    end

    set_current_user
  end

  def user_signed_in?
    Current.user.present?
  end

  private

  def fetch_user(name)
    user = User.find_by(user_name: name)

    if user.nil?
      raise AuthenticationError.new(
        'Enter a valid user name',
        code: 'AUTHENTICATION_ERROR',
        parameter: 'user name'
      )
    end

    user
  end

  def valid_password?(password)
    user.authenticate(password)
  end

  def set_current_user
    Current.user = user
  end
end

class LoginManager
  include ActiveModel::Validations

  attr_accessor :user_name, :password, :user

  validates :password, presence: true
  validates :user_name, presence: true
  validates :user, presence: true

  def initialize(user_name:, password:)
    @user_name  = user_name
    @password   = password
    @user       = fetch_user
  end

  def sign_in
    if valid_password?
      current_user
      return true
    end
    false
  end

  def token
    JsonWebToken.encode({ user_id: user.id })
  end

  private

  def valid_password?
    user.authenticate(password)
  end

  def current_user
    Current.user = user
  end

  def fetch_user
    User.find_by(user_name: user_name)
  end
end

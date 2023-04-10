module LoginHelper

  def generate_token(user)
    JsonWebToken.encode({ user_id: user.id })
  end

  def auth_header(user)
    { 'Authorization' => "Bearer #{generate_token(user)}" }
  end
end

RSpec.configure do |config|
  config.include LoginHelper
end
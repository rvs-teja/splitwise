class AuthenticationError < StandardError

  attr_accessor :code
  def initialize(message, code: 'AUTHENTICATION_ERROR')
    super(message)
    @code = code
  end
end
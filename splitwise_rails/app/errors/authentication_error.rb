class AuthenticationError < ApplicationError
  attr_reader :parameter

  def initialize(message, code: 'AUTHENTICATION_ERROR', parameter: nil)
    super(message: message, code: code)
    @parameter = parameter
  end
end
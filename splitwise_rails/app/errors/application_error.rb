class ApplicationError < StandardError
  attr_reader :code

  def initialize(message:, code:)
    super(message)
    @message = message
    @code = code
  end
end
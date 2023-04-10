module Mutations
  class Login < BaseMutation

    argument :user_name, String, required: true
    argument :password, String, required: true

    field :token, String
    def resolve(user_name:, password:)
      user = LoginManager.new(user_name: user_name, password: password)
      invalid_credentials unless user.valid?

      if user.sign_in
        {
          token: user.token
        }
      else
        invalid_credentials
      end

    end

    private

    def invalid_credentials
      raise AuthenticationError.new('Invalid credentials!', code: 'INVALID_CREDENTIALS')
    end
  end
end

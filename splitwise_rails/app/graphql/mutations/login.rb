module Mutations
  class Login < BaseMutation

    argument :user_name, String, required: true
    argument :password, String, required: true

    field :token, String
    field :errors, [String]

    def resolve(user_name:, password:)
      auth_manager = AuthenticationManager.new(user_name: user_name)
      auth_manager.login(password)
      {
        token: JsonWebToken.encode({ user_id: auth_manager.user.id }),
        errors: []
      }
    end
  end
end

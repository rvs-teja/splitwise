class ApplicationController < ActionController::API
  def current_user
    Current.user
  end
end

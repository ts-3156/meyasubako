class ApplicationController < ActionController::Base
  include LoggingHelper

  after_action :create_access_log

  private

  helper_method :user_signed_in?, :current_user

  def authenticate_user!
    unless user_signed_in?
      redirect_to root_path
    end
  end

  def login(user)
    reset_session
    session[:user_id] = user.id
  end

  def logout
    reset_session
  end

  def user_signed_in?
    current_user
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
end

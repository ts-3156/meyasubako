class SessionsController < ApplicationController
  def new
  end

  def create
    if login_locked?
      redirect_to login_path, alert: t('.locked')
      return
    end

    if (user = User.find_by(email: params[:email])) && user.authenticate(params[:password])
      login(user)
      redirect_to surveys_path
    else
      ahoy.track('Login failed')
      redirect_to login_path, alert: t('.failed', value: login_attempts)
    end
  end

  def destroy
    logout
    redirect_to root_path
  end

  private

  def login_locked?
    login_attempts >= 5
  end

  def login_attempts
    Ahoy::Event.where_event('Login failed').where(visit_id: current_visit&.id).where('time > ?', 5.minutes.ago).size
  end
end

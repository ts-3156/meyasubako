class SessionsController < ApplicationController
  def new
  end

  def create
    if (user = User.find_by(email: params[:email])) && user.authenticate(params[:password])
      login(user)
      redirect_to surveys_path
    else
      redirect_to login_path, alert: t('.failed')
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end

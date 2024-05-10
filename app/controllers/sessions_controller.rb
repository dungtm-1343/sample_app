class SessionsController < ApplicationController
  def create
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    if @user.try(:authenticate, params.dig(:session, :password))
      log_in @user
      forwarding_url = session[:forwarding_url]
      reset_session
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      session[:user_id] = @user.id
      redirect_to forwarding_url || @user
    else
      flash.now[:danger] = t "invalid_login"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_path, status: :see_other
  end
end

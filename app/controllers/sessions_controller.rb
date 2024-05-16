class SessionsController < ApplicationController
  def create
    user = find_user
    if authenticated? user
      handle_authenticated_user user
    else
      handle_unauthenticated_user
    end
  end

  def destroy
    log_out
    redirect_to root_path, status: :see_other
  end

  private

  def find_user
    User.find_by email: params.dig(:session, :email)&.downcase
  end

  def authenticated? user
    user.try(:authenticate, params.dig(:session, :password))
  end

  def handle_authenticated_user user
    if user.activated?
      handle_activated_user user
    else
      handle_unactivated_user
    end
  end

  def handle_activated_user user
    forwarding_url = session[:forwarding_url]
    reset_session
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    log_in user
    redirect_to forwarding_url || user
  end

  def handle_unactivated_user
    flash[:warning] = t "not_activated"
    redirect_to root_path, status: :see_other
  end

  def handle_unauthenticated_user
    flash.now[:danger] = t "invalid_login"
    render :new, status: :unprocessable_entity
  end
end

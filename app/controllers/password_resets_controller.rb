class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_mail
      flash[:info] = t "password_reset_mail_sent"
      redirect_to root_path
    else
      flash.now[:danger] = t "activerecord.flash.not_found"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if user_params[:password].empty?
      flash[:danger] = t "users.invalid_password"
      render :edit, status: :unprocessable_entity
    elsif @user.update user_params
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t "activerecord.flash.success"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "activerecord.flash.not_found"
    redirect_to root_path
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "users.unactivated"
    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_reset_expired"
    redirect_to new_password_reset_path
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
end

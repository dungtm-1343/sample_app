class UsersController < ApplicationController
  before_action :user
  before_action :logged_in_user, except: %i(new)
  before_action :correct_user, only: %i(delete update edit)
  before_action :admin, only: :destroy

  def index
    @pagy, @users = pagy(User.order_by_name, items: Settings.users.users_per_page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "activerecord.flash.success"
      reset_session
      log_in @user
      redirect_to @user, status: :see_other
    else
      flash[:error] = t "activerecord.flash.error"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t "activerecord.flash.success"
      redirect_to @user
    else
      flash[:error] = t "activerecord.flash.error"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.delete
      flash[:success] = t "users.delete_successfully"
    else
      flash[:error] = t "users.delete_failed"
    end
    redirect_to users_path
  end

  private

  def user
    @user = User.find_by id: params[:id].to_i

    return if @user

    flash[:warning] = t "activerecord.flash.not_found"
  end

  def correct_user
    return if current_user == @user

    flash[:error] = t "auth_failed"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit User::ATTRIBUTES
  end
end

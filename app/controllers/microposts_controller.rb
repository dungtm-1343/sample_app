class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def show; end

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params.dig(:micropost, :image)
    save_micropost
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "microposts.delete_success"
    else
      flash[:danger] = t "microposts.delete_failed"
    end
    redirect_to request.referer || root_url
  end

  private

  def save_micropost
    if @micropost.save
      flash[:success] = t "microposts.create_success"
      redirect_to root_path
    else
      @pagy, @feed_items = pagy current_user.feed,
                                items: Settings.users.items_per_page
      render "static_pages/home", status: :unprocessable_entity
    end
  end

  def micropost_params
    params.require(:micropost).permit Micropost::ATTRIBUTES
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "activerecord.flash.not_found"
    redirect_to request.referer || root_url
  end
end

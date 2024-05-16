class StaticPagesController < ApplicationController
  def contact; end

  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy current_user.feed,
                              items: Settings.users.items_per_page
  end
end

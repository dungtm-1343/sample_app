# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale

  def set_locale
    session[:locale] = params[:locale] if params[:locale]
    I18n.locale = session[:locale] || I18n.default_locale
  end
end

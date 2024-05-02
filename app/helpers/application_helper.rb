# This ApplicationHelper is a module that provides helper methods to be used across the application.
# frozen_string_literal: true

module ApplicationHelper
  def full_title page_title = ""
    base_title = t "app_title"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
end

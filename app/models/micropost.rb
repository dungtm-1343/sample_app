class Micropost < ApplicationRecord
  ATTRIBUTES = %i(content image).freeze

  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: Settings.microposts.resize_image
  end

  belongs_to :user
  validates :content, presence: true,
length: {maximum: Settings.microposts.max_length_content}
  validates :image, content_type: {in: Settings.microposts.image_type,
                                   message: I18n.t("microposts.image_format")},
                    size: {less_than: Settings.microposts.image_size.megabytes,
                           message: I18n.t("microposts.image_size")}

  scope :newest, -> { order created_at: :desc }
  scope :relate_post, ->(user_ids) { where user_id: user_ids }
end

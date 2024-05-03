class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: Settings.users.max_length_name }
  validates :email, presence: true, length: { maximum: Settings.users.max_length_email },
                    format: { with: Regexp.new(Settings.users.EMAIL_REGEX) }, uniqueness: { case_sensitive: false }
  has_secure_password

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end

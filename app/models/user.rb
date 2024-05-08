class User < ApplicationRecord
  ATTRIBUTES = %i[name email password password_confirmation].freeze

  validates :name, presence: true, length: { maximum: Settings.users.max_length_name }
  validates :email, presence: true, length: { maximum: Settings.users.max_length_email },
                    format: { with: Regexp.new(Settings.users.EMAIL_REGEX) }, uniqueness: { case_sensitive: false }
  has_secure_password

  before_save :downcase_email

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost
  end

  private

  def downcase_email
    email.downcase!
  end
end

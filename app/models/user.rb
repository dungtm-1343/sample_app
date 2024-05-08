class User < ApplicationRecord
  ATTRIBUTES = %i[name email password password_confirmation].freeze

  attr_accessor :remember_token

  validates :name, presence: true, length: { maximum: Settings.users.max_length_name }
  validates :email, presence: true, length: { maximum: Settings.users.max_length_email },
                    format: { with: Regexp.new(Settings.users.EMAIL_REGEX) }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: Settings.users.min_length_password }, allow_nil: true
  has_secure_password

  before_save :downcase_email

  scope :order_by_name, -> { order(:name) }

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  private

  def downcase_email
    email.downcase!
  end
end

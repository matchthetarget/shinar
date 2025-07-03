# == Schema Information
#
# Table name: users
#
#  id                    :bigint           not null, primary key
#  name                  :string           default("pending"), not null
#  timezone              :string           default("UTC")
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  preferred_language_id :bigint           not null
#
# Indexes
#
#  index_users_on_preferred_language_id  (preferred_language_id)
#
# Foreign Keys
#
#  fk_rails_...  (preferred_language_id => languages.id)
#
class User < ApplicationRecord
  belongs_to :preferred_language, class_name: "Language"

  has_many :created_chats, class_name: "Chat", foreign_key: "creator_id", dependent: :destroy
  has_many :chat_users, dependent: :destroy
  has_many :chats, through: :chat_users, source: :chat
  has_many :messages, foreign_key: "author_id", dependent: :destroy
  has_many :notification_tokens, dependent: :destroy

  before_create :set_random_name
  before_validation :set_default_language
  before_validation :set_default_timezone

  validates :name, presence: true

  def set_random_name
    self.name = Haikunator.haikunate(0)
  end

  def set_default_language
    self.preferred_language ||= Language.find_by(name_english: "English")
  end

  def set_default_timezone
    self.timezone ||= "America/Chicago"
  end
end

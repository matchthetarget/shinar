# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string           default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  has_many :created_chats, class_name: "Chat", foreign_key: "creator_id", dependent: :destroy
  has_many :chat_users, dependent: :destroy
  has_many :chats, through: :chat_users, source: :chat
  has_many :messages, foreign_key: "author_id", dependent: :destroy

  after_create :update_name, if: -> { name.blank? }

  validates :name, presence: true

  def update_name
    self.update name: Haikunator.haikunate(0)
  end
end

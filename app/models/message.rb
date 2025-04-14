# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint           not null
#  chat_id    :bigint           not null
#
# Indexes
#
#  index_messages_on_author_id  (author_id)
#  index_messages_on_chat_id    (chat_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (chat_id => chats.id)
#
class Message < ApplicationRecord
  belongs_to :chat, touch: true
  belongs_to :author, class_name: "User"

  validates :content, presence: true

  after_create_commit -> { broadcast_refresh_to chat }
  after_update_commit -> { broadcast_refresh_to chat }
  after_destroy_commit -> { broadcast_refresh_to chat }
end

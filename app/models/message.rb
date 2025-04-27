# == Schema Information
#
# Table name: messages
#
#  id                   :bigint           not null, primary key
#  content              :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  author_id            :bigint           not null
#  chat_id              :bigint           not null
#  original_language_id :bigint           not null
#
# Indexes
#
#  index_messages_on_author_id             (author_id)
#  index_messages_on_chat_id               (chat_id)
#  index_messages_on_original_language_id  (original_language_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (chat_id => chats.id)
#  fk_rails_...  (original_language_id => languages.id)
#
class Message < ApplicationRecord
  belongs_to :chat, touch: true
  belongs_to :author, class_name: "User"
  belongs_to :original_language, class_name: "Language"
  
  has_many :translations, dependent: :destroy

  validates :content, presence: true

  after_create_commit -> { broadcast_refresh_to chat }
  after_update_commit -> { broadcast_refresh_to chat }
  after_destroy_commit -> { broadcast_refresh_to chat }
  
  # Get the content in the specified language, translating if necessary
  def content_in(language)
    # Return original content if the requested language is the original language
    return content if language.id == original_language_id
    
    # Look for an existing translation
    translation = translations.find_by(language: language)
    
    # Return the translation if it exists
    return translation.content if translation.present?
    
    # No translation exists, so we would create one here
    # For now, this is just a placeholder - in a real app, this would call a translation API
    translated_text = "#{content} [Translated from #{original_language.name} to #{language.name}]"
    
    # Store the translation for future use
    new_translation = translations.create!(
      language: language,
      content: translated_text
    )
    
    new_translation.content
  end
end

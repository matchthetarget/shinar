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

  before_validation :set_original_language
  validates :content, presence: true

  # after_create_commit -> { broadcast_refresh_to chat }
  # after_update_commit -> { broadcast_refresh_to chat }
  # after_destroy_commit -> { broadcast_refresh_to chat }

  def set_original_language
    self.original_language = author.preferred_language
  end

  # Get the content in the specified language, translating if necessary
  def in_language(language)
    # Return original content if the requested language is the original language
    if language == original_language
      content
    elsif translation = translations.find_by(language: language)
      translation.content
    else
      translated_text = translate(language)

      new_translation = translations.create!(
        language: language,
        content: translated_text
      )

      new_translation.content
    end
  end

  private

  def translate(target_language)
    chat = AI::Chat.new
    chat.model = "gpt-4.1-nano"
    chat.messages = [
      {
        role: "system",
        content: "You are an expert translator. Your task is to translate text from the source language to the target language, doing your best to preserve meaning, tone, idiom, and formatting."
      },
      {
        role: "user",
        content: "Please translate the following text from #{original_language.name} (#{original_language.name_english}) to #{target_language.name} (#{target_language.name_english}):#{content}"
      },
      {
        role: "user",
        content: content
      }
    ]
    chat.schema = '{
      "name": "translation_schema",
      "schema": {
        "type": "object",
        "properties": {
          "translation": {
            "type": "string",
            "description": "The translated text."
          }
        },
        "required": [
          "translation"
        ],
        "additionalProperties": false
      },
      "strict": true
    }'

    chat.assistant!.fetch("translation")
  end
end

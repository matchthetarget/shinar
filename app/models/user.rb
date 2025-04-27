# == Schema Information
#
# Table name: users
#
#  id                    :bigint           not null, primary key
#  name                  :string           default("pending"), not null
#  name_customized       :boolean          default(FALSE)
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

  before_create :set_random_name
  before_validation :set_default_language
  after_save :translate_name_if_needed

  validates :name, presence: true

  def set_random_name
    self.name = Haikunator.haikunate(0)
    self.name_customized = false
  end

  def set_default_language
    self.preferred_language ||= Language.find_by(name_english: "English")
  end

  def translate_name_if_needed
    # Only translate if name hasn't been customized and preferred language has changed
    return if name_customized || !saved_change_to_preferred_language_id?

    # Get the previous and current language objects
    previous_language_id = preferred_language_id_before_last_save
    previous_language = Language.find(previous_language_id)
    current_language = preferred_language

    # Don't translate if the languages are the same
    return if previous_language.id == current_language.id

    # Translate the name
    chat = AI::Chat.new
    chat.model = "gpt-4.1-nano"
    chat.messages = [
      {
        role: "system",
        content: "You are an expert translator. Your task is to translate a username from the source language to the target language, preserving the meaning."
      },
      {
        role: "user",
        content: "Please translate the following username from #{previous_language.name} (#{previous_language.name_english}) to #{current_language.name} (#{current_language.name_english}): #{name}"
      }
    ]
    chat.schema = '{
      "name": "translation_schema",
      "schema": {
        "type": "object",
        "properties": {
          "translation": {
            "type": "string",
            "description": "The translated username."
          }
        },
        "required": [
          "translation"
        ],
        "additionalProperties": false
      },
      "strict": true
    }'

    translated_name = chat.assistant!.fetch("translation")
    update_column(:name, translated_name)
  end

  # Get the content of a message in the user's preferred language
  def view_message(message)
    message.content_in(preferred_language)
  end
end

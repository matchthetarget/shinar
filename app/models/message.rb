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
    
    # No translation exists, so translate using OpenAI
    translated_text = translate(language)
    
    # Store the translation for future use
    new_translation = translations.create!(
      language: language,
      content: translated_text
    )
    
    new_translation.content
  end
  
  private
  
  def translate(target_language)
    require "http"
    
    api_key = ENV["OPENAI_API_KEY"]
    url = "https://api.openai.com/v1/responses"
    
    payload = {
      model: "gpt-4.1-nano",
      input: [
        {
          role: "system",
          content: "You are a translation system. Your task is to translate text from the source language to the target language, preserving meaning, tone, and formatting."
        },
        {
          role: "user",
          content: "Translate the following text from #{original_language.name} (#{original_language.name_english}) to #{target_language.name} (#{target_language.name_english}):\n\n#{content}"
        }
      ],
      text: {
        format: {
          type: "json_schema",
          schema: {
            type: "object",
            properties: {
              translation: {
                type: "string",
                description: "The translated text"
              }
            },
            required: ["translation"],
            additionalProperties: false
          },
          strict: true
        }
      }
    }
    
    headers = {
      "Authorization" => "Bearer #{api_key}",
      "Content-Type" => "application/json"
    }
    
    begin
      response = HTTP.headers(headers).post(url, json: payload)
      
      if response.status.success?
        json_response = JSON.parse(response.body.to_s)
        output_text = json_response["output_text"]
        parsed_output = JSON.parse(output_text)
        return parsed_output["translation"]
      else
        Rails.logger.error("Translation API error: #{response.status} - #{response.body}")
        return "#{content} [Translation failed: API error]"
      end
    rescue => e
      Rails.logger.error("Translation error: #{e.message}")
      return "#{content} [Translation failed: #{e.message}]"
    end
  end
end

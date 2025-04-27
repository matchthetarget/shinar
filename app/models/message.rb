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
          name: "json",
          type: "json_schema",
          schema: {
            type: "object",
            properties: {
              translation: {
                type: "string",
                description: "The translated text"
              }
            },
            required: [ "translation" ],
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

    # Try up to 3 times with exponential backoff
    max_retries = 3
    retries = 0
    last_error = nil

    begin
      while retries < max_retries
        begin
          response = HTTP.headers(headers).timeout(30).post(url, json: payload)

          if response.status.success?
            json_response = JSON.parse(response.body.to_s)
            output_text = json_response["output_text"]
            parsed_output = JSON.parse(output_text)
            return parsed_output["translation"]
          elsif response.status.code == 429 || response.status.code >= 500
            # Rate limit or server error - retry with backoff
            retries += 1
            wait_time = (2 ** retries) # Exponential backoff: 2, 4, 8 seconds
            Rails.logger.warn("Translation API temporary error (retrying in #{wait_time}s): Status: #{response.status}, Body: #{response.body.to_s[0..200]}")
            sleep(wait_time) if retries < max_retries
            last_error = "Status: #{response.status}, Body: #{response.body.to_s[0..500]}"
          else
            # Client error - don't retry
            error_message = "Status: #{response.status}, Body: #{response.body.to_s[0..500]}"
            Rails.logger.error("Translation API error: #{error_message}")
            return "#{content} [Translation failed: #{error_message}]"
          end
        rescue => e
          retries += 1
          wait_time = (2 ** retries)
          Rails.logger.warn("Translation network error (retrying in #{wait_time}s): #{e.class}: #{e.message}")
          sleep(wait_time) if retries < max_retries
          last_error = "#{e.class}: #{e.message}"
        end
      end

      # If we got here, we failed after max retries
      error_details = last_error || "Max retries exceeded"
      Rails.logger.error("Translation failed after #{max_retries} attempts: #{error_details}")
      "#{content} [Translation failed after #{max_retries} attempts: #{error_details}]"
    rescue => e
      # Catch any errors in the retry loop itself
      error_details = "#{e.class}: #{e.message}\n#{e.backtrace[0..3].join("\n")}"
      Rails.logger.error("Translation retry loop error: #{error_details}")
      "#{content} [Translation failed: #{e.class}: #{e.message}]"
    end
  end
end

json.extract! message, :id, :chat_id, :author_id, :content, :parent_id, :created_at, :updated_at
json.url message_url(message, format: :json)

json.extract! chat_user, :id, :chat_id, :user_id, :created_at, :updated_at
json.url chat_user_url(chat_user, format: :json)

class AddChatUsersCountToChats < ActiveRecord::Migration[8.0]
  def up
    add_column :chats, :chat_users_count, :integer, default: 0, null: false
    
    # Update existing records
    Chat.find_each do |chat|
      Chat.reset_counters(chat.id, :chat_users)
    end
  end

  def down
    remove_column :chats, :chat_users_count
  end
end

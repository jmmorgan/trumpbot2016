class RemoveChatSessionChatJson < ActiveRecord::Migration
  def change
    remove_column :chat_sessions, :chat_json
  end
end

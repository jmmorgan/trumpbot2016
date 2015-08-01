class CreateChatSessions < ActiveRecord::Migration
  def change
    create_table :chat_sessions do |t|
      t.string :session_id
      t.timestamps null: false
      t.text :chat_json
    end

    add_index :chat_sessions, :session_id
  end
end

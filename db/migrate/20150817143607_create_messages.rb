class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :chat_session_id
      t.boolean :inbound
      t.string :message_text

      t.timestamps null: false
    end

    add_index :messages, :chat_session_id
  end
end

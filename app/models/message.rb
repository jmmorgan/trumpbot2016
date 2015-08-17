class Message < ActiveRecord::Base

  validates :chat_session_id, presence: true
  validates :message_text, presence: true

  belongs_to :chat_session
end

class ChatSession < ActiveRecord::Base

  def chat
    result = Chat.from_json(self.chat_json || '{}')
    result.chat_session_id = self.id
    result
  end
end

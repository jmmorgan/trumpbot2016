class ChatSession < ActiveRecord::Base

  def chat
    Chat.from_json(self.chat_json || '{}')
  end
end

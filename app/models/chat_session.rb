class ChatSession < ActiveRecord::Base

  before_save :update_chat_json

  def chat
    @chat ||= Chat.from_json(self.chat_json || '{}')
  end

  def transcript
    chat.transcript # TODO: We will be getting rid of Chat soon
  end

  def respond(input)
    chat.respond(input) # TODO: We will be getting rid of Chat soon
  end

  def predicates
    chat.predicates # TODO: We will be getting rid of Chat soon
  end

  def requests
    chat.requests # TODO: We will be getting rid of Chat soon
  end

  def responses
    chat.responses # TODO: We will be getting rid of Chat soon
  end

  private 

  def build_chat
    result = Chat.from_json(self.chat_json || '{}')
    result.chat_session_id = self.id
    result
  end

  def update_chat_json
    self.chat_json = chat.to_json
  end
end

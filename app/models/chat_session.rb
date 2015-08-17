class ChatSession < ActiveRecord::Base

  has_one :predicates
  has_many :messages

  after_initialize :ensure_predicates
  after_initialize :ensure_messages

  def transcript
    result = ''
    reqs = self.requests
    resps = self.responses
    reqs.each_index do |i|
      result << "You: #{reqs[i].message_text}" << "\n"
      if (response = resps[i])
        result << "TrumBot: #{response.message_text}" << "\n"
      end
    end

    result
  end

  def respond(input)
    self.messages << Message.new(message_text: input, inbound: true)
    predicates['_chat_session_id'] = self.id
    bot_brain_response = BotBrain.new.respond(input, self.requests.map(&:message_text), predicates)
    response = bot_brain_response[:responses].join(' ')

    self.messages << Message.new(message_text: response, inbound: false)
    ChatResponse.new(bot_brain_response, predicates)
  end

  def requests
    self.messages.select{|msg| msg.inbound == true}
  end

  def responses
    self.messages.select{|msg| msg.inbound == false}
  end

  private 

  def ensure_predicates
    self.predicates ||= build_predicates
  end

  def ensure_messages
    self.messages ||= []
  end
end

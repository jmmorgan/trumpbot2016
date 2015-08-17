class Chat
  attr_accessor :chat_session_id, :requests, :responses

  def initialize(chat_session_id)
    @chat_session_id = chat_session_id
    @requests = []
    @responses = []
  end

  def respond(input, predicates)
    @requests << input
    predicates['_chat_session_id'] = @chat_session_id
    
    bot_brain_response = BotBrain.new.respond(input, @requests, predicates)
    response = bot_brain_response[:responses].join(' ')

    @responses << response
    ChatResponse.new(bot_brain_response, predicates)
  end

  def transcript
    result = ''
    @requests.each_index do |i|
      result << "You: #{@requests[i]}" << "\n"
      if (response =  responses[i])
        result << "TrumBot: #{response}" << "\n"
      end
    end

    result
  end

  def to_json
    {
      'chat_session_id' => @chat_session_id,
      'requests' => @requests,
      'responses' => @responses
      }.to_json
  end

  def self.from_json(json)
    hash = JSON.parse(json)
    result = self.allocate
    result.chat_session_id = hash["chat_session_id"]
    result.requests = hash['requests'] || []
    result.responses = hash['responses'] || []
    result
  end
end

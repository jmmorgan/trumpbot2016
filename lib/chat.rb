class Chat
  attr_accessor :chat_session_id, :requests, :responses, :predicates, :that

  def initialize(chat_session_id)
    @chat_session_id = chat_session_id
    @requests = []
    @responses = []
    @predicates = {}
  end

  def respond(input)
    @requests << input
    @predicates['_chat_session_id'] = @chat_session_id
    
    brain_bot_response = BotBrain.new.respond(input, @requests, predicates)
    response = brain_bot_response[:response]

    @responses << response
    response
  end

  def clear
    @requests.clear
    @responses.clear
    @predicates.clear
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
      'responses' => @responses,
      'predicates' => @predicates,
      }.to_json
  end

  def self.from_json(json)
    hash = JSON.parse(json)
    result = self.allocate
    result.chat_session_id = hash["chat_session_id"]
    result.requests = hash['requests'] || []
    result.responses = hash['responses'] || []
    result.predicates = hash['predicates'] || {}
    result
  end
end

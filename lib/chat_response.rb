class ChatResponse
  attr_accessor :outputs

  def initialize(bot_brain_response)
    @outputs = bot_brain_response[:responses]
  end
end

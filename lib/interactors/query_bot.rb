class Interactors::QueryBot < Interactor

  def call
    chat = @request[:chat] ||= Chat.new(nil)
    @response[:chat] = chat
    chat_response = chat.respond(@request[:input])
    @response[:outputs] = chat_response.outputs
    @response[:inputs] = chat_response.inputs
    @response
  end
end

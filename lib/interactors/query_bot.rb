class Interactors::QueryBot < Interactor

  def call
    chat = @request[:chat] ||= Chat.new(nil)
    @response[:chat] = chat
    chat_response = chat.respond(@request[:input])
    @response[:outputs] = chat_response.outputs
    @response[:inputs] = chat_response.inputs
    @response[:matched_patterns] = chat_response.matched_patterns
    @response[:source_files] = chat_response.source_files
    @response
  end
end

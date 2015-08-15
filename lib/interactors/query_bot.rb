class Interactors::QueryBot < Interactor

  def call
    chat = @request[:chat] ||= Chat.new(nil)
    if (that = @request[:that])
      # TODO: This is a temporary hack until we implement ChatRequest in which logic like this will be encapsulated
      chat.predicates['that'] = that
    end
    chat_response = chat.respond(@request[:input])
    chat_response
  end
end

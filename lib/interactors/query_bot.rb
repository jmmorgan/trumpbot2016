class Interactors::QueryBot < Interactor

  def call
    chat_session = @request[:chat_session] ||= ChatSession.new
    if (that = @request[:that])
      # TODO: This is a temporary hack until we implement ChatRequest in which logic like this will be encapsulated
      chat_session.predicates['that'] = that
    end
    chat_response = chat_session.respond(@request[:input])
    chat_response
  end
end

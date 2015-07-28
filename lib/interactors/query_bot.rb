class Interactors::QueryBot < Interactor

  def call
    @response[:output] = Bot.new.respond(@request[:input])
    @response
  end
end

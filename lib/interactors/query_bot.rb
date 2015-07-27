class Interactors::QueryBot < Interactor

  def call
    @response[:output] = "I'm impressed."
    @response
  end
end

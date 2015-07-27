class Interactor
  attr_reader :request, :response

  def initialize(request)
    @request = request
    @response = Response.new
  end

end

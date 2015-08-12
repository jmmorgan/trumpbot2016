class TrainingController < ApplicationController

  def index
    if (input = params[:input])
      @response = Interactors::QueryBot.new(@request).call
    end
  end

end

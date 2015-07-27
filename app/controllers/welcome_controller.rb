class WelcomeController < ApplicationController

  def index
    if (input = params[:input])
      @response = Interactors::QueryBot.new(@request).call
      output = @response[:output]
      session[:inputs] ||= []
      session[:outputs] ||= []
      session[:inputs] << input
      session[:outputs] << output
    end
  end

  def reset
    session[:inputs] = []
    session[:outputs] = []
    redirect_to :root
  end
end

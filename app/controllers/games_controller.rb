class GamesController < ApplicationController
  def index
    # TODO : Only show games that are ready for primetime
    @games = Game.all
  end

  def show
    # TODO : Only show games that are ready for primetime
    # TODO : Redirect this to Characters#index
    @game = Game.find(params[:id])
  end
end

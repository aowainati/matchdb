class CharactersController < ApplicationController
  def index
    # TODO : Same as game#show currently
  end

  def show
    @character = Character.find(params[:id])
  end
end

class CombosController < ApplicationController

  def index
    @card = Card.find(params[:card])
    @combos = @card.combos
    @onyx = params[:onyx] == 'true'
  end

end

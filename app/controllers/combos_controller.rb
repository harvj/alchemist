class CombosController < ApplicationController

  def index
    @card = Card.find(params[:card])
    @combos = @card.combos.sort_by{|c| -c.score}
    @onyx = params[:onyx] == 'true'
  end

end

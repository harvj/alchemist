class CombosController < ApplicationController

  def index
    @card = Card.find(params[:card])
    @combos = @card.combos.sort_by{|c| -c.score}
  end

end

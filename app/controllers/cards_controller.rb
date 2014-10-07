class CardsController < ApplicationController

  def index
    @cards = Card.all.order('base_offense DESC')
  end

end

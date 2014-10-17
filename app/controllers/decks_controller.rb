class DecksController < ApplicationController

  def index
    @deck = Deck.first.includes(:cards)
  end

end

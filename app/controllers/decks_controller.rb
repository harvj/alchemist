class DecksController < ApplicationController

  def index
    @deck = Deck.first.includes(:cards)
  end

  def show
    @deck = Deck.find(params[:id])
    if params[:cards]
      @card_ids = remove_duplicates(params[:cards].split(','))
      @param_string = @card_ids.join(',')

      @cards = Card.where(id: @card_ids).order(:id)
    else
      @cards = @deck.cards.combo.order(:id).uniq
      @card_ids = @cards.map(&:id)
    end
  end

  private

  def remove_duplicates(array)
    counts = Hash.new(0)
    array.each{|i|counts[i]+=1}
    counts.reject{|k,v|v!=1}.keys
  end

end

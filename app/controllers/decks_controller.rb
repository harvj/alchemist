class DecksController < ApplicationController
  def index
    @deck = Deck.first.includes(:cards)
  end

  def show
    @deck = Deck.first
    @sets = @deck.cards.group_by {|i| i.card_name }.map do |name,combos|
      {name: name, combos: combos, set_score: combos.select{|c| c.power > 64}.count * 100 + combos.select{|c| c.power > 63}.count}
    end.sort{|a,b| b[:set_score] <=> a[:set_score]}
  end
end

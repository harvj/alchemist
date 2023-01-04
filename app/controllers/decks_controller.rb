class DecksController < ApplicationController
  def index
    @deck = Deck.first.includes(:cards)
  end

  def show
    @deck = Deck.first
    @sets = @deck.cards.group_by {|i| i.card_name }.map do |name,combos|
      {name: name, combos: combos, set_score: combos.map(&:final_offense).max * combos.select{|c| c.final_offense > 34}.count}
    end.sort{|a,b| b[:set_score] <=> a[:set_score]}
  end
end

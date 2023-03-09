class DecksController < ApplicationController
  def index
    @deck = Deck.first.includes(:cards)
  end

  def show
    @deck = Deck.first
    @sets = @deck.cards.group_by {|i| i.card_name }.map do |name,combos|
      offense = combos.select{|c| c.final_offense >= 34 and c.final_defense > 25}.count
      defense = combos.select{|c| c.final_defense >= 34}.count
      power = combos.select{|c| c.power >= 65}.count
      total = combos.count
      {
        name: name,
        combos: combos,
        set_score: offense * 1000000 + defense * 10000 + power * 100 + total
      }
    end.sort{|a,b| b[:set_score] <=> a[:set_score]}
  end
end

class DecksController < ApplicationController
  def index
    @deck = current_deck.includes(:cards)
  end

  def show
    @all = {
      power: 0,
      known_power: 0,
      total: 0,
      known: 0
    }
    @sets = current_deck.cards.group_by {|i| i.deck_card_id }.map do |id,combos|
      # offense = combos.select{|c| c.final_offense >= 34 and c.final_defense >= 25}.count
      # defense = combos.select{|c| c.final_defense >= 34}.count
      # power = combos.select{|c| c.power >= 67}.count
      gold_combos = combos.select{|c| ['gold', 'diamond', 'onyx'].include?(c.final_rarity)}
      known_combos = combos.select{|c| c.user_combo_id.present?}
      known_gold_combos = gold_combos.select{|c| c.user_combo_id.present?}
      known = known_combos.count
      total = combos.count
      offense = gold_combos.sum(&:final_offense)
      known_offense = known_gold_combos.sum(&:final_offense)
      defense = gold_combos.sum(&:final_defense)
      known_defense = known_gold_combos.sum(&:final_defense)
      power = offense + defense
      known_power = known_offense + known_defense

      @all[:power] += power
      @all[:known_power] += known_power
      @all[:total] += total
      @all[:known] += known

      info = combos.first

      {
        combos: combos,
        name: info.card_name,
        level: info.card_level,
        rarity: info.card_rarity_value,
        rarity_name: info.card_rarity,
        offense: offense,
        known_offense: known_offense,
        defense: defense,
        known_defense: known_defense,
        power: power,
        known_power: known_power,
        total: total,
        known: known
      }
    end.sort_by{ |i| sort_by_criteria(i) }
  end

  private

  def sort_by_params
    SORT_OPTIONS[deck_sort] || :power
  end

  def sort_by_criteria(i)
    [*sort_by_params].map { |param| ASC_SORT_OPTIONS.include?(param) ? i[param] : -i[param] }
  end

  def display_stat
    param_value = [*sort_by_params].map(&:to_s).join
    if param_value.include?('offense')
      :offense
    elsif param_value.include?('defense')
      :defense
    else
      :power
    end
  end
  helper_method :display_stat
end

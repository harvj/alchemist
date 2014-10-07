class Combo < ActiveRecord::Base

  belongs_to :card
  belongs_to :match, class_name: 'Card'
  belongs_to :final, class_name: 'Card'

  def offense_for_level(level)
    final.base_offense + (dominant_multiplier * (level - 1))
  end

  def defense_for_level(level)
    final.base_defense + (dominant_multiplier * (level - 1))
  end

  def dominant_multiplier
    [card.multiplier, match.multiplier].max
  end

  def score
    offense_for_level(5) + (defense_for_level(5) * 0.6)
  end

end

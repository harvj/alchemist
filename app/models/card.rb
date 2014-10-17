class Card < ActiveRecord::Base

  validates_uniqueness_of :name

  has_many :combos
  has_many :deck_cards

  scope :combo, -> { where(classification: 'combo') }

  def combos
    super.includes(:final, :match)
  end

  def display_name
    name.titleize
  end

  def final?
    classification == 'final'
  end

  def multiplier
    case color
    when 'diamond'
      4
    when 'gold'
      3
    when 'silver'
      2
    when 'bronze'
      1
    end
  end

  def calculate_score
    first_tier_combos  = combos.to_a.delete_if{|c| c.score <= Combo::TIERS[:first]}
    second_tier_combos = combos.to_a.delete_if{|c| c.score > Combo::TIERS[:first] || c.score <= Combo::TIERS[:second]}
    third_tier_combos  = combos.to_a.delete_if{|c| c.score > Combo::TIERS[:second] || c.score <= Combo::TIERS[:third]}
    fourth_tier_combos  = combos.to_a.delete_if{|c| c.score > Combo::TIERS[:third] || c.score <= Combo::TIERS[:fourth]}
    first_tier_combos.count * 1000 + second_tier_combos.count * 100 + third_tier_combos.count * 10 + fourth_tier_combos.count
  end

  def calculate_score!
    self.score = calculate_score
    save!
  end

end

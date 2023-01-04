class Card < ApplicationRecord
  RARITIES = {
    bronze: 0,
    silver: 1,
    gold: 2,
    diamond: 3,
    onyx: 4
  }
  FORMS = { combo: 0, final: 1 }
  FUSIONS = { orb: 0,
    absorb: 1, siphon: 2,
    critical_strike: 3, amplify: 4,
    crushing_blow: 5, pierce: 6,
    counter_attack: 7, reflect: 8,
    curse: 9, weaken: 10,
    protection: 11, block: 12
  }

  validates :name, :base_offense, :base_defense, :rarity, :form, :fusion, presence: true
  validates :name, uniqueness: { scope: :rarity }

  enum rarity: RARITIES
  enum form: FORMS
  enum fusion: FUSIONS

  has_many :combos
  has_many :deck_cards

  scope :combo, -> { where(form: 'combo') }

  def combos
    super.includes(:final, :match)
  end

  def display_name
    name.titleize
  end

  def adjustment
    case rarity
    when 'diamond'
      { combo: 4, onyx: 20 }
    when 'gold'
      { combo: 3, onyx: 23 }
    when 'silver'
      { combo: 2, onyx: 25 }
    when 'bronze'
      { combo: 1, onyx: 27 }
    end
  end

  def calculate_score
    first_tier_combos  = combos.to_a.delete_if{|c| c.score <= Combo::TIERS[:first]}
    second_tier_combos = combos.to_a.delete_if{|c| c.score > Combo::TIERS[:first] || c.score <= Combo::TIERS[:second]}
    third_tier_combos  = combos.to_a.delete_if{|c| c.score > Combo::TIERS[:second] || c.score <= Combo::TIERS[:third]}
    fourth_tier_combos  = combos.to_a.delete_if{|c| c.score > Combo::TIERS[:third] || c.score <= Combo::TIERS[:fourth]}
    first_tier_combos.count * 100000 + second_tier_combos.count * 10000 + third_tier_combos.count * 100 + fourth_tier_combos.count
  end

  def calculate_score!
    self.score = calculate_score
    save!
  end
end

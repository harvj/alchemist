class Card < ApplicationRecord
  validates :name, :base_offense, :base_defense, :rarity, :form, :fusion, presence: true
  validates :name, uniqueness: { scope: :rarity }

  enum rarity: RARITIES
  enum form: FORMS
  enum fusion: FUSIONS

  has_many :combos
  has_many :deck_cards

  scope :combo, -> { where(form: 'combo') }

  def combos
    id_table = combo? ? 'cards' : 'finals'
    Combo.find_by_sql(<<~SQL
      SELECT x.*,
        base_multiplier * 5 + base_offense as offense,
        base_multiplier * 5 + base_defense as defense,
        diamond_mod + base_offense + 20 as diamond_offense,
        diamond_mod + base_defense + 20 as diamond_defense,
        onyx_mod + base_offense + 20 as onyx_offense,
        onyx_mod + base_defense + 20 as onyx_defense,
        (diamond_mod + base_offense + 20) + (diamond_mod + base_defense + 20) as power
      FROM (SELECT
          cards.id as card_id,
          cards.name as card_name,
          matches.id as match_id,
          matches.name as match_name,
          finals.id as final_id,
          finals.name as final_name,
          finals.base_offense,
          finals.base_defense,
          cards.rarity as card_rarity,
          matches.rarity as match_rarity,
          finals.rarity as final_rarity,
          greatest(cards.rarity, matches.rarity) as high_rarity,
          greatest(cards.rarity, matches.rarity) + 1 as base_multiplier,
          (case when finals.rarity = 0 then 9
                when finals.rarity = 1 then 7
                when finals.rarity = 2 then 5 else 3 end
          ) as onyx_mod,
          (case when finals.rarity = 0 then 7
                when finals.rarity = 1 then 5
                when finals.rarity = 2 then 3 else 0 end
          ) as diamond_mod
        FROM cards
        JOIN combos ON combos.card_id = cards.id
        JOIN cards matches ON combos.match_id = matches.id
        JOIN cards finals ON combos.final_id = finals.id
        WHERE cards.form = 0
        AND #{id_table}.id = #{id}
      ) as x
      ORDER BY power DESC, diamond_offense DESC, final_name ASC, card_name ASC
    SQL
    )
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

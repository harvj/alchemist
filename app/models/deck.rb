class Deck < ApplicationRecord
  belongs_to :user
  has_many :deck_cards

  validates :name, presence: true

  def has_available?(combo)
    cards.where(id: combo.match.id).any?
  end

  def cards
    sql = <<~SQL
      select bar.*,
        base_offense + onyx_modifier + ((final_level - 1) * rarity_multiplier) as final_offense,
        base_defense + onyx_modifier + ((final_level - 1) * rarity_multiplier) as final_defense,
        (base_offense + onyx_modifier + ((final_level - 1) * rarity_multiplier))
         +
        (base_defense + onyx_modifier + ((final_level - 1) * rarity_multiplier)) as power
      from (
      select
        foo.*,
        (case when final_rarity IN (0,1) then
          round((card_level + match_level) / 2.0, 0)::integer
          else
          round((card_level + match_level) / 2.0, 0)::integer + 1
          end
        ) as final_level
      from (
      select
        cards.id as card_id,
        deck_cards.id as deck_card_id,
        deck_cards.rarity as card_rarity,
        deck_cards.rarity as card_rarity_value,
        deck_cards.level as card_level,
        cards.name as card_name,
        match_cards.name as match_name,
        matches.level as match_level,
        finals.name as final_name,
        (case when deck_cards.rarity = 4 AND matches.rarity = 4 then
          (case when finals.rarity = 0 then 9
            when finals.rarity = 1 then 7
            when finals.rarity = 2 then 5 else 3 end)
          when deck_cards.rarity = 4 OR matches.rarity = 4 then
           (case when finals.rarity = 0 then 7
            when finals.rarity = 1 then 5
            when finals.rarity = 2 then 3 else 0 end)
          else 0 end
          ) as onyx_modifier,
        (case when deck_cards.rarity = 4 AND matches.rarity = 4 then 4 else
          (case when deck_cards.rarity = 4 OR matches.rarity = 4 then 3 else finals.rarity end)
        end) as final_rarity,
        (case when greatest(deck_cards.rarity, matches.rarity) = 4 then 4 else greatest(deck_cards.rarity, matches.rarity) + 1 end) as rarity_multiplier,
        finals.base_offense,
        finals.base_defense,
        user_combos.id as user_combo_id
      from deck_cards
      join cards on cards.id = deck_cards.card_id --- original card name
      join combos on combos.card_id = cards.id
      join deck_cards matches on combos.match_id = matches.card_id AND deck_cards.id <> matches.id AND matches.deck_id = :id
      join cards match_cards on combos.match_id = match_cards.id
      join cards finals on combos.final_id = finals.id
      left outer join user_combos on user_combos.combo_id = combos.id and user_combos.user_id = :user_id and user_combos.researched IS NOT NULL
      where deck_cards.deck_id = :id
      order by deck_cards.id asc
      ) as foo
      ) as bar
    SQL
    Combo.find_by_sql([ sql, { id: id, user_id: user_id } ])
  end
end

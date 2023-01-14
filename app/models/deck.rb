class Deck < ApplicationRecord
  has_many :deck_cards

  validates :name, presence: true

  def has_available?(combo)
    cards.where(id: combo.match.id).any?
  end

  def cards
    Deck.find_by_sql(<<~SQL
      select bar.*,
        bar.final_offense + bar.final_defense as power,
        round(((bar.final_offense * bar.off_adj) * (bar.final_defense * bar.def_adj) / 10),1) as score
      from (
      select
        foo.card_id,
        foo.deck_card_id,
        foo.card_name,
        foo.card_rarity,
        foo.match_name,
        foo.final_level,
        foo.final_rarity,
        foo.final_name,
        foo.base_offense + modifier + (level_multiplier * rarity_multiplier) as final_offense,
        foo.base_defense + modifier + (level_multiplier * rarity_multiplier) as final_defense,
        round((case when (foo.base_offense + modifier + (level_multiplier * rarity_multiplier) > 28)
                  then 1.1 + ((foo.base_offense + modifier + (level_multiplier * rarity_multiplier) - 28) / 80.0)
                  else 1 end),2) as off_adj,
        round((case when (foo.base_defense + modifier + (level_multiplier * rarity_multiplier) > 26)
                  then 1.07 + ((foo.base_defense + modifier + (level_multiplier * rarity_multiplier) - 26) / 80.0)
                  else 1 end),2) as def_adj
      from (
      select
        cards.id as card_id,
        deck_cards.id as deck_card_id,
        deck_cards.rarity as card_rarity,
        cards.name as card_name,
        match_cards.name as match_name,
        greatest(deck_cards.level, matches.level) + 1 as final_level,
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
          ) as modifier,
        (case when deck_cards.rarity = 4 AND matches.rarity = 4 then 4 else
          (case when deck_cards.rarity = 4 OR matches.rarity = 4 then 3 else finals.rarity end)
        end) as final_rarity,
        greatest(deck_cards.level, matches.level) as level_multiplier,
          (case when greatest(deck_cards.rarity, matches.rarity) = 4 then 4 else greatest(deck_cards.rarity, matches.rarity) + 1 end) as rarity_multiplier,
          finals.base_offense,
        finals.base_defense
      from deck_cards
      join cards on cards.id = deck_cards.card_id --- original card name
      join combos on combos.card_id = cards.id
      join deck_cards matches on combos.match_id = matches.card_id AND deck_cards.id <> matches.id
      join cards match_cards on combos.match_id = match_cards.id
      join cards finals on combos.final_id = finals.id
      order by deck_cards.id asc
      ) as foo
      ) as bar
    SQL
    )
  end
end

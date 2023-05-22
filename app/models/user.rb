class User < ApplicationRecord
  validates :username, presence: true

  has_many :decks
  has_many :user_cards
  has_many :user_combos

  def combo_cards(params={})
    sort = <<~SQL
      name asc
    SQL
    sql = <<~SQL
      select *,
        (known_combo_count::numeric / available_combo_count) as known_combo_pct
      from (
        select
          cards.*,
          (select #{deck_card_sql(params[:deck_id])}) as deck_card_count,
          (#{available_combo_count_sql}) as available_combo_count,
          (#{known_combo_count_sql}) as known_combo_count,
          (#{unknown_combo_count_sql}) as unknown_combo_count,
          (#{potential_deck_power_sql}) as potential_deck_power
        from user_cards
        join cards on cards.id = user_cards.card_id
        where user_cards.user_id = :id
      ) as f
      #{order_sql(params[:sort])}
    SQL
    Card.find_by_sql([sql, { id: id }])
  end

  def available_combos(card_id = nil)
    card_filter = card_id.present? ? "and card_id = #{card_id}" : "and card_id <= match_id"
    sql = <<~SQL
      with foo as (select card_id from user_cards where user_cards.user_id = ?)
      select *
      from combos
      where combos.card_id IN (select card_id from foo)
      and combos.match_id IN (select card_id from foo)
      #{card_filter}
    SQL
    Combo.find_by_sql([sql, id])
  end

  def available_combo_count_sql
    <<~SQL
      select
        count(*)
      from combos
      join user_cards card_uc on card_uc.card_id = combos.card_id and card_uc.user_id = :id
      join user_cards match_uc on match_uc.card_id = combos.match_id and match_uc.user_id = :id
      where combos.card_id = cards.id
    SQL
  end

  def unknown_combo_count_sql
    <<~SQL
      #{available_combo_count_sql}
      and combos.id NOT IN (select combo_id from user_combos where user_id = :id AND researched IS NOT NULL)
    SQL
  end

  def deck_card_sql(deck_id)
    return 'NULL' if deck_id.nil?
    <<~SQL
      count(id) from deck_cards where card_id = cards.id and deck_cards.deck_id = #{deck_id}
    SQL
  end

  def order_sql(sort=nil)
    <<~SQL
      order by #{sort || 'name asc'}
    SQL
  end

  def known_combo_count_sql
    <<~SQL
      select
        count(*)
      from user_combos
      join combos on combos.id = user_combos.combo_id
      where combos.card_id = cards.id
      and user_combos.user_id = :id
      and user_combos.researched IS NOT NULL
    SQL
  end

  def potential_deck_power_sql
    <<~SQL
    select
      sum(countable_power) as potential_deck_power
    from ( select
      *,
      (case when power >= 26 then power else 0 end) as countable_power
    from ( select
      *,
      offense + defense as power
    from (
      select
        c.id as card_id,
        c.rarity,
        matches.id,
        matches.name as match_name,
        matches.rarity,
        finals.name as final_name,
        finals.rarity,
        finals.base_offense + 5 * (greatest(c.rarity, matches.rarity) + 1) as offense,
        finals.base_defense + 5 * (greatest(c.rarity, matches.rarity) + 1) as defense
      from user_cards
      join combos on user_cards.card_id = combos.card_id
      and combos.card_id IN (select card_id from user_cards where user_id = :id)
      and combos.match_id IN (select distinct(card_id) from deck_cards where deck_id IN (select id from decks where user_id = :id))
      join cards c on c.id = combos.card_id
      join cards matches on matches.id = combos.match_id
      join cards finals on finals.id = combos.final_id
      join decks on decks.user_id = :id
      join deck_cards on matches.id = deck_cards.card_id and deck_cards.deck_id = decks.id
      where c.id = cards.id
      and user_cards.user_id = :id
      and finals.rarity > 1
      order by user_cards.card_id, match_id
    ) as i
    ) as j
    ) as k
    group by card_id
    SQL
  end
end

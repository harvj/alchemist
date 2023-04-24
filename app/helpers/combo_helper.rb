module ComboHelper

  def card_as_combo_list_item(combo, options={})
    card = combo.final
    match = combo.match
    onyx = options[:onyx]

    in_deck = current_deck.has_available?(combo) ? 'deck' : ''
    content_tag :li, class: "list-group-item card #{card.rarity} #{in_deck}" do
      link_to(card.display_name.html_safe, card) +
      if onyx
        content_tag(:span, number_with_precision(combo.onyx_score, precision: 1), class: "badge onyx")
      else
        content_tag(:span, number_with_precision(combo.score, precision: 1), class: "badge #{tier_class(combo.score)}")
      end +
      content_tag(:span, combo.stat_for_level(:defense, 6, onyx: onyx), class: 'badge defense') +
      content_tag(:span, combo.stat_for_level(:offense, 6, onyx: onyx), class: 'badge offense') +
      content_tag(:span, match.display_name, class: "badge #{match.rarity}")
    end
  end

  def offense_class(combo)
    return if combo.final_offense.nil?
    tier = if combo.final_offense >= 36
      'offense-0'
    elsif combo.final_offense >= 34
      'offense-1'
    elsif combo.final_offense >= 30
      'offense-2'
    elsif combo.final_offense >= 26
      'offense-3'
    elsif combo.final_offense >= 22
      'offense-4'
    else
      'offense-5'
    end
    known = combo.user_combo_id.present? ? 'known' : 'unknown'
    [combo.card_rarity, tier, known].join(' ')
  end

  def defense_class(combo)
    return if combo.final_defense.nil?
    tier = if combo.final_defense >= 36
      'defense-0'
    elsif combo.final_defense >= 34
      'defense-1'
    elsif combo.final_defense >= 30
      'defense-2'
    elsif combo.final_defense >= 26
      'defense-3'
    elsif combo.final_defense >= 24
      'defense-4'
    else
      'defense-5'
    end
    known = combo.user_combo_id.present? ? 'known' : 'unknown'
    [combo.card_rarity, tier, known].join(' ')
  end
end

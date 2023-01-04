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

  def tier_class(score, options={})
    return if score.nil?
    if score > 100
      'tier-0'
    elsif score > Combo::TIERS[:first]
      'tier-1'
    elsif score > Combo::TIERS[:second]
      'tier-2'
    elsif score > Combo::TIERS[:third]
      'tier-3'
    elsif score > Combo::TIERS[:fourth]
      'tier-4'
    else
      'tier-5'
    end
  end

end

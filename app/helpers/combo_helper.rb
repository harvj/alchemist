module ComboHelper

  def card_as_combo_list_item(combo)
    card = combo.final
    match = combo.match

    in_deck = current_deck.has_available?(combo) ? 'deck' : ''
    content_tag :li, class: "list-group-item card #{card.color} #{in_deck}" do
      card.display_name.html_safe +
      content_tag(:span, number_with_precision(combo.score, precision: 1), class: "badge #{tier_class(combo.score)}") +
      content_tag(:span, combo.defense_for_level(5), class: 'badge defense') +
      content_tag(:span, combo.offense_for_level(5), class: 'badge offense') +
      content_tag(:span, match.display_name, class: "badge #{match.color}")
    end
  end

  def tier_class(score)
    return if score.nil?
    if score > Combo::TIERS[:first]
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

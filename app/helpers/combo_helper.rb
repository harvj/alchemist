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

  def offense_class(value)
    return if value.nil?
    if value >= 36
      'offense-0'
    elsif value >= 34
      'offense-1'
    elsif value >= 30
      'offense-2'
    elsif value >= 26
      'offense-3'
    elsif value >= 22
      'offense-4'
    else
      'offense-5'
    end
  end

  def defense_class(value)
    return if value.nil?
    if value >= 36
      'defense-0'
    elsif value >= 34
      'defense-1'
    elsif value >= 30
      'defense-2'
    elsif value >= 26
      'defense-3'
    elsif value >= 24
      'defense-4'
    else
      'defense-5'
    end
  end
end

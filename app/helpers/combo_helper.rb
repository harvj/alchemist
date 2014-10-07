module ComboHelper

  def card_as_combo_list_item(combo)
    card = combo.final
    match = combo.match
    content_tag :li, class: "list-group-item card #{card.color}" do
      card.display_name.html_safe +
      content_tag(:span, card.final? ? 'F' : 'C', class: "badge #{card.classification}") +
      content_tag(:span, combo.defense_for_level(5), class: 'badge defense') +
      content_tag(:span, combo.offense_for_level(5), class: 'badge offense') +
      content_tag(:span, match.display_name, class: "badge #{match.color}")
    end
  end

end

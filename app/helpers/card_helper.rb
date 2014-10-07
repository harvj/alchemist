module CardHelper

  def card_as_list_item(card)
    content_tag :li, class: "list-group-item card #{card.color}" do
      card.display_name.html_safe +
      content_tag(:span, card.final? ? 'F' : 'C', class: "badge #{card.classification}") +
      content_tag(:span, card.base_defense, class: 'badge defense') +
      content_tag(:span, card.base_offense, class: 'badge offense')
    end
  end

end

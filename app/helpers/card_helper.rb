module CardHelper

  def card_as_list_item(card, options={})
    content_tag :li, class: "list-group-item card #{card.rarity}" do
      # (options[:show_add_card] ? new_card_form(card) : ''.html_safe) +
      link_to(card.display_name.html_safe, card) +
      content_tag(:span, card.final? ? 'F' : 'C', class: "badge #{card.form}") +
      content_tag(:span, card.base_defense, class: 'badge defense') +
      content_tag(:span, card.base_offense, class: 'badge offense')
    end
  end

  def new_card_form(card)
    form_with model: UserCard.new, class: 'inline' do |f|
      f.hidden_field :user_card, :user_id, value: current_user.id
      f.hidden_field :user_card, :card_id, value: card.id
      button_tag "add"
    end
  end

  def side_nav_card_class(card)
    deck = card.onyx ? 'onyx' : 'not-onyx'
    researched = card.unknown_combo_count == 0 ? 'researched' : ''
    ['user', card.rarity, researched, deck].join(' ')
  end
end

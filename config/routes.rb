Rails.application.routes.draw do
  root 'cards#index'

  resources :cards, only: %i(index show)

  resources :combos, only: %i(index)

  resources :decks, only: %i(show) do
    resources :deck_cards, only: %i(create destroy)
  end

  resources :user_combos, only: %i(create)
  resources :user_cards, only: %i(create)
end

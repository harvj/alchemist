Rails.application.routes.draw do
  root 'cards#index'

  resources :cards, only: [:index, :show]

  resources :combos, only: [:index]

  resources :decks, only: [:show] do
    resources :deck_cards, only: %i(create destroy)
  end
end

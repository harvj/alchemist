Rails.application.routes.draw do

 root 'cards#index'

 resources :cards, only: [:index]

 resources :combos, only: [:index]

end

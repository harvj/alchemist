class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :load_user_cards

  def index
  end

  def current_deck
    @current_deck ||= Deck.first
  end
  helper_method :current_deck

  def current_user
    @current_user ||= User.first
  end
  helper_method :current_user

  def load_user_cards
    @user_cards = Card.where(id: current_user.user_cards.pluck(:card_id)).to_h { |i| [i.name, 0] }
    current_user.unknown_combo_counts.each do |i|
      @user_cards[i.card_name] = i.count
    end
  end
end

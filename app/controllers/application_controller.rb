class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  SORT_OPTIONS = {
    'power' => :power,
    'knownpower' => :known_power,
    'offense' => :offense,
    'knownoffense' => :known_offense,
    'defense' => :defense,
    'knowndefense' => :known_defense,
    'alpha' => [:name, :level],
    'rarity' => [:rarity, :name, :level],
    'raritypower' => [:rarity, :power],
    'raritypowerknown' => [:rarity, :known_power],
    'level' => [:level, :rarity, :name]
  }.freeze

  ASC_SORT_OPTIONS = [:name].freeze

  SQL_ORDER_OPTIONS = {
    'alpha' => "name asc",
    'deck' => "deck_card_count desc, rarity desc, name",
    'rarity' => "rarity desc, name asc",
    'known' => "known_combo_pct desc, name asc",
    'unknown' => "unknown_combo_count desc, name asc",
    'power' => "potential_deck_power desc"
  }.freeze

  def index
  end

  def current_deck
    @current_deck ||= current_user.decks.first
  end
  helper_method :current_deck

  def current_user
    session[:user_id] = params[:user_id] if params[:user_id].present?
    @current_user ||= User.find_by(id: session[:user_id]) || User.first
  end
  helper_method :current_user

  def order_by_param
    SQL_ORDER_OPTIONS[side_sort || 'deck']
  end
  helper_method :order_by_param

  def current_page_params
    request.params.slice(:decksort, :combosort, :sidesort)
  end
  helper_method :current_page_params

  def deck_sort
    current_user.update_column(:deck_sort_pref, params[:decksort]) if params[:decksort].present? && current_user.deck_sort_pref != params[:decksort]
    current_user.deck_sort_pref
  end
  helper_method :deck_sort

  def combo_sort
    current_user.update_column(:combo_sort_pref, params[:combosort]) if params[:combosort].present? && current_user.combo_sort_pref != params[:combosort]
    current_user.combo_sort_pref
  end
  helper_method :combo_sort

  def side_sort
    current_user.update_column(:side_sort_pref, params[:sidesort]) if params[:sidesort].present? && current_user.side_sort_pref != params[:sidesort]
    current_user.side_sort_pref
  end
  helper_method :side_sort
end

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
    'known' => "known_combo_pct desc, name asc",
    'unknown' => "unknown_combo_count desc, name asc"
  }.freeze

  def index
  end

  def current_deck
    @current_deck ||= current_user.decks.first
  end
  helper_method :current_deck

  def current_user
    @current_user ||= User.find_by(username: 'kalef2p')
  end
  helper_method :current_user

  def order_by_param
    SQL_ORDER_OPTIONS[params[:ssort] || 'deck']
  end
  helper_method :order_by_param

  def current_page_params
    request.params.slice(:sort)
  end
  helper_method :current_page_params

  def sort_by_params
    SORT_OPTIONS[params[:sort]] || default_sort
  end

  def sort_by_criteria(i)
    [*sort_by_params].map { |param| ASC_SORT_OPTIONS.include?(param) ? i[param] : -i[param] }
  end

  def default_sort
    :power
  end
end

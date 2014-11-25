class DecksController < ApplicationController

  def index
    @deck = Deck.first.includes(:cards)
  end

  def show
    @params_hash = {}

    @deck = Deck.find(params[:id])
    if params[:cards]
      parse_params

      @cards = []
      @params_hash.each do |key,val|
        val.to_i.times { @cards << Card.find(key) }
      end
    else
      @cards = @deck.cards.combo.order(:id)
      @cards.each do |card|
        key = card.id.to_s
        @params_hash[key].present? ? @params_hash[key] += 1 : @params_hash[key] = 1
      end
    end
  end

  private

  def parse_params
    params[:cards].each do |key,val|
      next unless params_key_is_a_card_id?(key) && params_value_is_valid?(val)
      @params_hash[key] = val
    end
  end

  def params_key_is_a_card_id?(key)
    key.to_i > 0 && key.to_i <= Card.count
  end

  def params_value_is_valid?(val)
    val.to_i >= 0 && val.to_i <= 3
  end

  def remove_duplicates(array)
    counts = Hash.new(0)
    array.each{|i|counts[i]+=1}
    counts.reject{|k,v|v!=1}.keys
  end

end

class CardsController < ApplicationController

  def index
    @cards = Card.all.order('base_offense DESC')
  end

  def show
    @card = Card.find(params[:id])
  end

   def update
    @card = Release.find(params[:id])
    if @card.update_attributes!(params[:card])
      respond_to do |format|
        format.json { render json: {status: :ok} }
      end
    end
  end

end

class CombosController < ApplicationController

  def index
    @combos = Combo.with_stats
  end
end

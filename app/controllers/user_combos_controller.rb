class UserCombosController < ApplicationController
  def create
    card_id = params[:card_id]
    passed_combos = params[:combos]

    known_combo_ids = passed_combos.map{|i| i.split.map(&:to_i)}.flatten
    unknown_combo_ids = Combo.where("(card_id = #{card_id} OR match_id = #{card_id}) AND id NOT IN(#{known_combo_ids.join(',')})").pluck(:id)

    uncreated_user_combos = known_combo_ids - UserCombo.where(user: current_user).pluck(:combo_id)
    uncreated_user_combos.each do |combo_id|
      UserCombo.create(user: current_user, combo_id: combo_id)
    end

    UserCombo.where(user: current_user, combo_id: known_combo_ids).update_all(researched: Time.now)
    UserCombo.where(user: current_user, combo_id: unknown_combo_ids).update_all(researched: nil)

    redirect_to card_path(card_id)
  end
end

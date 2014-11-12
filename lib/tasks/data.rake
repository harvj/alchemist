namespace :data do
  desc "Calculate and store card scores"
  task :card_scores => :environment do
    Card.combo.each { |c| c.calculate_score! }
  end

  desc "Calculate and store combo scores"
  task :combo_scores => :environment do
    Combo.all.each { |c| c.calculate_score! }
  end
end

namespace :data do
  desc "Recalculate card scores"
  task :card_scores => :environment do
    Card.combo.each { |c| c.calculate_score! }
  end
end

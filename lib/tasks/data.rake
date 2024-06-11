require 'csv'

namespace :data do
  desc "Calculate and store card scores"
  task :card_scores => :environment do
    Card.combo.each { |c| c.calculate_score! }
  end

  desc "Calculate and store combo scores"
  task :combo_scores => :environment do
    Combo.all.each { |c| c.calculate_score! }
  end

  namespace :import do
    desc "Import new cards"
    task cards: :environment do
      CSV.foreach(File.join(Rails.root, 'db/imports/cards', "#{ENV['FILE']}.csv")) do |row|
        if !Card.find_by(name: row[0])
          puts "Creating card #{row[0]}"
          Card.create!(
            name: row[0],
            rarity: Card::RARITIES[row[1].to_sym],
            base_offense: row[2],
            base_defense: row[3],
            form: Card::FORMS[row[4].to_sym],
            fusion: Card::FUSIONS[row[5].tr(' ','_').to_sym],
            origin: Card::ORIGINS[row[6].tr(' ','_').to_sym],
            onyx_available: row[7]
          )
        end
      end
    end
  end

  namespace :import do
    desc "Import new cards"
    task combos: :environment do
      CSV.foreach(File.join(Rails.root, 'db/imports/combos', "#{ENV['FILE']}.csv")) do |row|
        card_id = Card.find_by(name: row[0])&.id
        match_id = Card.find_by(name: row[1])&.id
        final_id = Card.find_by(name: row[2])&.id

        puts "No card with name #{row[0]}" if card_id.nil?
        puts "No match with name #{row[1]}" if match_id.nil?
        puts "No final with name #{row[2]}" if final_id.nil?

        if !Combo.find_by(card_id: card_id, match_id: match_id)
          puts "Creating combo #{row[0]}, #{row[1]}: #{row[2]}"
          Combo.create!(card_id: card_id, match_id: match_id, final_id: final_id)
        end
      end
    end
  end
end

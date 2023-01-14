class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  RARITIES = {
    bronze: 0,
    silver: 1,
    gold: 2,
    diamond: 3,
    onyx: 4
  }
  FORMS = { combo: 0, final: 1 }
  FUSIONS = {
    orb: 0,
    absorb: 1, siphon: 2,
    critical_strike: 3, amplify: 4,
    crushing_blow: 5, pierce: 6,
    counter_attack: 7, reflect: 8,
    curse: 9, weaken: 10,
    protection: 11, block: 12
  }
end

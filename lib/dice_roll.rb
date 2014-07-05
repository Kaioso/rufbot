require 'entropy'

class DiceRoll
  def initialize(listener, dice_description)
    @listener = listener
    @range_max, @times, @modifier, @per_roll = 
      dice_description.values_at :sides, :rolls, :result_modifier, :per_roll_modifier
    ensure_defaults
  end
  
  def execute
    results = Array.new(@times) { Entropy::from_one_to(@range_max) + @per_roll }
    total = results.inject(&:+) + @modifier
    @listener.show_roll_result({rolls: results, total: total})
  end
  

  private

  def ensure_defaults
    @range_max ||= 6
    @times ||= 1
    @modifier ||= 0
    @per_roll ||= 0
  end
end

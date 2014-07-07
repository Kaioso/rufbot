require 'dice'

class WildDice
  def initialize(listener, dice_description)
    @rolls, @sides, @modifier = dice_description.values_at :rolls, :sides, :modifier
    @listener = listener
    ensure_defaults
  end

  def execute
    rolls = Dice.explode(@rolls, @sides) { |nums| nums.inject(&:+) }
    wild = Dice.roll(1, 6)[0]
    modified_rolls = rolls.map { |n| n + @modifier }
    modified_wild = wild + @modifier

    result = drop_lowest(modified_rolls, modified_wild)
    results = {
      rolls: modified_rolls,
      wild: modified_wild,
      bust?: rolls.count(1) > 0 && wild == 1,
      result: result
    }
    @listener.show_roll_result results
  end

  
  private

  def ensure_defaults
    @rolls ||= 1
    @sides ||= 4
    @modifier ||= 0
  end

  def drop_lowest(rolls, wild)
    roll_list = [*rolls, wild]
    lowest_n = nil
    lowest_i = nil
    dropped = roll_list.each_with_index do |n, i|
      if lowest_n.nil? || lowest_n > n
        lowest_n = n
        lowest_i = i
      end
    end
    roll_list.delete_at(lowest_i) unless lowest_i.nil?
    return roll_list
  end
end

require 'dice'

class WestendDice
  def initialize(listener, roll_description)
    @listener = listener
    @pool, @modifier = roll_description.values_at :dice, :modifier
    ensure_defaults
  end

  def execute
    rolls = Dice.roll(@pool - 1, 6)
    wild = Dice.roll(1, 6)[0]
    result = {
      rolls: rolls,
      wild: wild,
      bust?: bust?(wild),
      total: get_total(rolls, wild)
    }
    @listener.show_roll_result result
  end

  private

  def ensure_defaults
    @pool = 1 if @pool.nil? or @pool < 1
    @modifier ||= 0
  end

  def bust?(wild)
    wild == 1
  end

  def get_total(rolls, wild)
    rolls.inject(&:+) + wild + @modifier rescue wild + @modifier
  end
end

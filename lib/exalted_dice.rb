require 'dice'

class ExaltedDice
  def initialize(listener, pool)
    @listener = listener
    @pool = pool
    ensure_defaults
  end

  def execute
    rolls = Dice.roll(@pool, 10)
    result = {
      rolls: rolls,
      hits: get_hits(rolls)
    }
    @listener.show_roll_result(result)
  end

  private

  def ensure_defaults
    @pool = 1 if @pool.nil? || @pool < 1
  end

  def get_hits(rolls)
    rolls.inject(0) do |memo, n|
      memo + case n
             when 7..9 then 1
             when 10 then 2
             else 0
             end
    end
  end
end

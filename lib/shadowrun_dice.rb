require 'dice_roll'

class ShadowrunDice
  def initialize(listener, pool)
    @listener = listener
    @pool = pool
  end
  
  def execute
    DiceRoll.new(self, {sides: 6, rolls: @pool}).execute
  end

  def show_roll_result(results)
    rolls = results[:rolls]
    hits = calc_hits(rolls)
    glitch = was_glitch?(rolls)
    hit_results = {
      rolls: rolls,
      hits: hits,
      glitch?: glitch,
      critical_glitch?: glitch && hits <= 0
    }
    @listener.show_roll_result(hit_results)
  end

  
  private

  def calc_hits(rolls)
    (rolls.select { |r| r >= 5 }).length
  end

  def was_glitch?(rolls)
    rolls.count(1) >= (rolls.length / 2)
  end
end

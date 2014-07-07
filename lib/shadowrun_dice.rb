require 'dice_roll'

class ShadowrunDice
  def initialize(listener, roll_description)
    @listener = listener
    @pool, @edge = roll_description.values_at :pool, :edge?
  end
  
  def execute
    @all_rolls = []
    DiceRoll.new(self, {sides: 6, rolls: @pool}).execute
  end

  def show_roll_result(results)
    @all_rolls += results[:rolls]
    show_results unless rolled_edge? results[:rolls]
  end

  
  private

  def rolled_edge?(rolls)
    sixes = rolls.count 6
    if @edge && sixes > 0
      DiceRoll.new(self, {sides: 6, rolls: sixes}).execute
      return true
    else
      return false
    end
  end

  def show_results
    hits = calc_hits(@all_rolls)
    glitch = was_glitch?(@all_rolls)
    hit_results = {
      rolls: @all_rolls,
      hits: hits,
      glitch?: glitch,
      critical_glitch?: glitch && hits <= 0
    }
    @listener.show_roll_result hit_results
  end

  def calc_hits(rolls)
    (rolls.select { |r| r >= 5 }).length
  end

  def was_glitch?(rolls)
    rolls.count(1) >= (rolls.length / 2)
  end
end

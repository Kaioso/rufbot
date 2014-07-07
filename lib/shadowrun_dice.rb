require 'dice'

class ShadowrunDice
  def initialize(listener, roll_description)
    @listener = listener
    @pool, @edge = roll_description.values_at :pool, :edge?
  end
  
  def execute
    show(@edge ? Dice.explode(@pool, 6) : Dice.roll(@pool, 6))
  end

  
  private
  
  def show(rolls)
    hits = calc_hits rolls
    glitch = was_glitch? rolls
    hit_results = {
      rolls: rolls,
      hits: hits,
      glitch?: glitch,
      critical_glitch?: glitch && hits <= 0
    }
    @listener.show_roll_result hit_results
  end

  def calc_hits(rolls)
    puts "This is the calc_hits thing: #{rolls.to_s}"
    (rolls.select { |r| r >= 5 }).length
  end

  def was_glitch?(rolls)
    rolls.count(1) >= (rolls.length / 2)
  end
end

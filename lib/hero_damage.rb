require 'dice'

class HeroDamage
  def initialize(listener, roll_description)
    @body_damage_table = [0, 1, 1, 1, 1, 2]
    @listener = listener
    @dc, @modifier = roll_description.values_at :dc, :modifier
    ensure_defaults
  end

  def execute
    show_from_rolls Dice.roll(@dc, 6), half_roll
  end

  
  private

  def ensure_defaults
    @dc ||= 1
    @modifier ||= 0
  end

  def half_roll
    return [] unless @dc.is_a? Float
    _, fractional = @dc.to_s.split "."
    return fractional.to_i == 5 ? Dice.roll(1, 6) : []
  end

  def show_from_rolls(rolls, half)
    body = get_body(rolls, half)
    show_results rolls + half, body, get_stun(rolls, half), get_knockback(body)
  end

  def show_results(rolls, body, stun, knock_back)
    result = {
      rolls: rolls,
      stun: stun,
      body: body,
      staggered?: staggered?(knock_back)
    }
    result[:knock_back_distance] = knock_back if result[:staggered?]
    @listener.show_roll_result result
  end

  def get_body(rolls, half)
    half_value = (half.empty? or half[0] >= 3) ? 0 : 1
    half_value + (rolls).inject(0) do |memo, n|
      memo + @body_damage_table[n - 1]
    end
  end

  def get_stun(rolls, half)
    roll_total = rolls.inject(&:+)
    half_total = (half[0] + 1) / 2 rescue 0
    return roll_total + half_total + @modifier
  end

  def get_knockback(body)
    (body - Dice.roll(2, 6).inject(&:+)) * 2
  end

  def staggered?(knock_back)
    knock_back >= 0
  end
end

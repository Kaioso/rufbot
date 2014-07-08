require 'dice'

class HeroAttack
  def initialize(listener, ocv)
    @listener = listener
    @ocv = ocv
  end

  def execute
    total = (@ocv + 11) - Dice.roll_for_total(3, 6)
    @listener.show_roll_result({total: total})
  end
end

require 'entropy'

module Dice
  def Dice.roll(times, sides)
    Array.new(times) { Entropy::from_one_to sides }
  end

  def Dice.explode(times, sides, &folder)
    rolls = Array.new(times) do
      roll = Entropy::from_one_to(sides)
      rolls = [roll]
      while roll == sides
        roll = Entropy::from_one_to sides
        rolls << roll
      end
      folder.nil? ? rolls : folder.call(rolls)
    end
    return rolls.flatten
  end

  def Dice.roll_for_total(times, sides)
    Dice.roll(times, sides).inject(&:+)
  end
end

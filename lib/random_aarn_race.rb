require 'dice'

class RandomAarnRace
  def initialize(listener)
    @listener = listener
    humans = r "%{random} Human", %w(Jerolan Habruken Igan Camarian Zhan Kaipu Renzvaja).map(&self.method(:r))
    satyrs = r "%{random} Satyr", %w(Pan Buck Faun).map(&self.method(:r))
    ardlins = r "%{random} Ardlin", %w(City Forest Mountains Swamp Plains Cave Snow River Sea Sand Bush Tree).map(&self.method(:r))
    all = [humans, satyrs, ardlins, r("Mongrel"), r("Orchaeya"), r("Harpy"), r("Naga"), r("Lenneshin"), r("Ghorma"), r("Centaur")]

    monsters = %w(Ghrok D\'zont Skull\ Imp Dreamling Salamander Spirit\ Animal).map(&self.method(:r))
    monsters_sans = r("%{random}", monsters)
    thera = r "Theramorph %{random}", [*all, monsters_sans]
    undead = r("%{random}", %w(Dhampire Anima\ Possessing\ a\(n\) Phantom Araenid Deadwalker Vampire Lich).map do |dead|
      r(dead + " %{random}", [*all, monsters_sans])
    end)
    monsters_all = r("%{random}", monsters + [thera, undead])
    @races = r("%{random}", [*all, monsters_all])
  end

  def execute
    @listener.your_race_is(@races.to_s)
  end

  private

  def r(name, suff=[])
    AarnRace.new(name, suff)
  end
end

class AarnRace
  def initialize(race_name, randoms=[])
    @race_name = race_name
    @randoms = randoms
  end

  def to_s
    return @race_name % {random: random}
  end

  private

  def random
    return @randoms[Dice.roll_single(@randoms.length) - 1] unless @randoms.empty?
  end
end

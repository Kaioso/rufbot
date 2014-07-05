module Entropy
  RANDOMIZER = Random.new
  
  def Entropy.from_one_to(n); (RANDOMIZER.rand n.floor) + 1; end
end

require 'rspec'
require 'entropy'
require 'dice_test_helpers'
require 'savage_dice'

RSpec.describe SavageDice do
  before :each do
    Entropy::RANDOMIZER = RandomFake.new
    @listener = DiceRollListenerFake.new
  end

  it '' do
    
  end
end

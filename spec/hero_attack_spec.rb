require 'rspec'
require 'entropy'
require 'hero_attack'
require 'dice_test_helpers'

RSpec.describe HeroAttack do
  before :each do
    Entropy::RANDOMIZER = RandomFake.new
    @listener = DiceRollListenerFake.new
  end

  it 'is your OCV plus 11 with all rolls of zero' do
    Entropy::RANDOMIZER.return_chain = [-1, -1, -1]
    HeroAttack.new(@listener, 3).execute
    expect(@listener.last_roll_result[:total]).to eq(14)
  end

  it 'subtracts three dice rolls from the total' do
    Entropy::RANDOMIZER.return_chain = [0, 0, 0]
    HeroAttack.new(@listener, 3).execute
    expect(@listener.last_roll_result[:total]).to eq(11)
  end
end

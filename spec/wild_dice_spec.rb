require 'rspec'
require 'entropy'
require 'wild_dice'
require 'dice_test_helpers'

RSpec.describe WildDice do
  before :each do
    Entropy::RANDOMIZER = RandomFake.new
    @listener = DiceRollListenerFake.new
  end

  it 'tacks on an extra wild (d6) dice to a normal dice roll' do
    WildDice.new(@listener, {rolls: 2, sides: 4}).execute
    counts = [Entropy::RANDOMIZER.ranges_given.count(4), Entropy::RANDOMIZER.ranges_given.count(6)]
    expect(counts).to eq([2, 1])
  end

  it 'separates the rolls done and the wild dice rolled in the results' do
    WildDice.new(@listener, {rolls: 2, sides: 4}).execute
    rolls_count = @listener.last_roll_result[:rolls].length
    wild = @listener.last_roll_result[:wild]
    expect(wild.nil?).to be false
    expect(rolls_count).to eq(2)
  end

  it 'rerolls max rolls, adding the maximum to the result of the roll' do
    Entropy::RANDOMIZER.return_chain = [3, 3, 1, 2, 1]
    WildDice.new(@listener, {rolls: 2, sides: 4}).execute
    expect(@listener.last_roll_result[:rolls]).to eq([10, 3])
  end

  it 'drops the lowest in the result' do
    Entropy::RANDOMIZER.return_chain = [2, 0, 1]
    WildDice.new(@listener, {rolls: 2, sides: 4}).execute
    expect(@listener.last_roll_result[:result]).to eq([3, 2])
  end

  it 'can take a modifier for each roll' do
    WildDice.new(@listener, {rolls: 1, sides: 4, modifier: 4}).execute
    expect(@listener.last_roll_result.values_at(:rolls, :wild)).to eq([[5], 5])
  end

  it 'is a bust when the user rolls snake eyes (1 on wild and regular roll)' do
    Entropy::RANDOMIZER.return_chain = [0, 2, 0]
    WildDice.new(@listener, {rolls: 2, sides: 4}).execute
    expect(@listener.last_roll_result[:bust?]).to be true
  end

  it 'should ignore modifiers when calculating a bust' do
    Entropy::RANDOMIZER.return_chain = [0, 2, 0]
    WildDice.new(@listener, {rolls: 2, sides: 4, modifier: 2}).execute
    expect(@listener.last_roll_result[:bust?]).to be true
  end
end

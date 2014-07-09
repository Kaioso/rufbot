require 'rspec'
require 'dice_test_helpers'
require 'entropy'
require 'westend_dice'

RSpec.describe WestendDice do
  before :each do
    Entropy::RANDOMIZER = RandomFake.new
    @listener = DiceRollListenerFake.new
  end

  it 'produces a set of n - 1 rolls' do
    WestendDice.new(@listener, {dice: 4}).execute
    expect(@listener.last_roll_result[:rolls].length).to eq(3)
  end

  it 'rolls a wild die for the last die in the pool' do
    WestendDice.new(@listener, {dice: 4}).execute
    expect(@listener.last_roll_result[:wild]).to eq(1)
  end

  it 'defaults to one die if given nothing' do
    WestendDice.new(@listener, {}).execute
    expect(@listener.last_roll_result[:rolls].length).to eq(0)
  end

  it 'defaults to one die if given less than 1' do
    WestendDice.new(@listener, {dice: -1}).execute
    expect(@listener.last_roll_result[:rolls].length).to eq(0)
  end

  it 'indicates a bust if the wild roll is 1' do
    WestendDice.new(@listener, {dice: 3}).execute
    expect(@listener.last_roll_result[:bust?]).to be true
  end

  it 'is not a bust otherwise' do
    Entropy::RANDOMIZER.return_chain = [3]
    WestendDice.new(@listener, {dice: 1}).execute
    expect(@listener.last_roll_result[:bust?]).to be false
  end

  it 'totals the rolls together' do
    WestendDice.new(@listener, {dice: 3}).execute
    expect(@listener.last_roll_result[:total]).to eq(3)
  end

  it 'accepts a modifier to the roll total' do
    WestendDice.new(@listener, {dice: 3, modifier: 5}).execute
    expect(@listener.last_roll_result[:total]).to eq(8)
  end

  it 'adds the wild and modifier even if there are no rolls' do
    WestendDice.new(@listener, {dice: 1, modifier: 5}).execute
    expect(@listener.last_roll_result[:total]).to eq(6)
  end
end

require 'rspec'
require 'entropy'
require 'dice_test_helpers'
require 'exalted_dice'

RSpec.describe ExaltedDice do
  before :each do
    Entropy::RANDOMIZER = RandomFake.new
    @listener = DiceRollListenerFake.new
  end

  it 'rolls a given number of 10 sided dice and gives back the results of each' do
    ExaltedDice.new(@listener, 5).execute
    expect(@listener.last_roll_result[:rolls].length).to eq(5)
  end

  it 'counts rolls below 7 as no hits' do
    ExaltedDice.new(@listener, 5).execute
    expect(@listener.last_roll_result[:hits]).to eq(0)
  end

  it 'counts rolls above or equal to 7 as hits' do
    Entropy::RANDOMIZER.return_chain = [6, 7, 8, 7, 2]
    ExaltedDice.new(@listener, 5).execute
    expect(@listener.last_roll_result[:hits]).to eq(4)
  end

  it 'counts a roll of 10 as 2 hits' do
    Entropy::RANDOMIZER.return_chain = [6, 9, 8, 7, 2]
    ExaltedDice.new(@listener, 5).execute
    expect(@listener.last_roll_result[:hits]).to eq(5)
  end

  it 'should always roll at least one dice' do
    ExaltedDice.new(@listener, 0).execute
    expect(@listener.last_roll_result[:rolls].length).to eq(1)
  end
end

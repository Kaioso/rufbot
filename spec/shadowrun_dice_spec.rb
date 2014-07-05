require 'rspec'
require 'entropy'
require 'shadowrun_dice'
require 'dice_test_helpers'

RSpec.describe ShadowrunDice do
  before :each do
    Entropy::RANDOMIZER = RandomFake.new
    @listener = DiceRollListenerFake.new
  end

  it 'should roll a number of d6 and report the results' do
    ShadowrunDice.new(@listener, 5).execute

    expect(@listener.last_roll_result[:rolls]).to eq([1, 1, 1, 1, 1])
  end

  it 'shows the number of hits instead of the total of the rolls' do
    Entropy::RANDOMIZER.return_chain = [0, 2, 4, 1, 5]
    ShadowrunDice.new(@listener, 5).execute
    expect(@listener.last_roll_result[:hits]).to eq(2)
  end

  it 'reports a glitch if at least half the rolls are 1' do
    Entropy::RANDOMIZER.return_chain = [0, 0, 0, 4, 2, 3]
    ShadowrunDice.new(@listener, 6).execute
    expect(@listener.last_roll_result[:glitch?]).to eq(true)
  end

  it 'is a critical glitch if you get a glitch with no hits' do
    Entropy::RANDOMIZER.return_chain = [0, 0, 0, 2, 2, 1]
    ShadowrunDice.new(@listener, 6).execute
    expect(@listener.last_roll_result[:critical_glitch?]).to eq(true)
  end

  # roll number should be integral
  it 'should round down the dice pool if not given an integral' do
    ShadowrunDice.new(@listener, 3.7).execute
    expect(@listener.last_roll_result[:rolls].length).to eq(3)
  end
  
  # edge
  

  # rule of six
end

require 'rspec'
require 'entropy'
require 'hero_damage'
require 'dice_test_helpers'

RSpec.describe HeroDamage do
  before :each do
    Entropy::RANDOMIZER = RandomFake.new
    @listener = DiceRollListenerFake.new
  end

  it 'rolls a number of six sided dice' do
    HeroDamage.new(@listener, {dc: 4}).execute
    expect(@listener.last_roll_result[:rolls].length).to eq(4)
  end

  it 'rolls an extra die if given a fractional die' do
    HeroDamage.new(@listener, {dc: 4.5}).execute
    expect(@listener.last_roll_result[:rolls].length).to eq(5)
  end

  it 'totals the rolls as stun damage' do
    HeroDamage.new(@listener, {dc: 4}).execute
    expect(@listener.last_roll_result[:stun]).to eq(4)
  end

  it 'adds half the roll + 1 for a half die' do
    Entropy::RANDOMIZER.return_chain = [0, 0, 2]
    HeroDamage.new(@listener, {dc: 2.5}).execute
    expect(@listener.last_roll_result[:stun]).to eq(4)
  end

  it 'can take a modifier for stun damage' do
    HeroDamage.new(@listener, {dc: 2, modifier: 2}).execute
    expect(@listener.last_roll_result[:stun]).to eq(4)
  end

  it 'deals zero body damage for each roll of 1' do
    HeroDamage.new(@listener, {dc: 2}).execute
    expect(@listener.last_roll_result[:body]).to eq(0)
  end

  it 'deals one body damage for each roll above 1 and not 6' do
    Entropy::RANDOMIZER.return_chain = [1, 2]
    HeroDamage.new(@listener, {dc: 3}).execute
    expect(@listener.last_roll_result[:body]).to eq(2)
  end

  it 'deals two body damage on a roll of 6' do
    Entropy::RANDOMIZER.return_chain = [1, 2, 5]
    HeroDamage.new(@listener, {dc: 3}).execute
    expect(@listener.last_roll_result[:body]).to eq(4)
  end

  it 'body includes the half roll should there be one into the calculation' do
    Entropy::RANDOMIZER.return_chain = [1, 2, 5, 1]
    HeroDamage.new(@listener, {dc: 3.5}).execute
    expect(@listener.last_roll_result[:body]).to eq(5)
  end

  it 'should not include the half roll if it is greater than 2' do
    Entropy::RANDOMIZER.return_chain = [1, 2, 5, 3]
    HeroDamage.new(@listener, {dc: 3.5}).execute
    expect(@listener.last_roll_result[:body]).to eq(4)
  end

  it 'shows no knockback' do
    HeroDamage.new(@listener, {dc: 3}).execute
    expect(@listener.last_roll_result[:staggered?]).to be false
  end

   it 'shows knockback if there is some' do
    Entropy::RANDOMIZER.return_chain = [1, 2, 5, 0, 1]
    HeroDamage.new(@listener, {dc: 3}).execute
    expect(@listener.last_roll_result[:staggered?]).to be true
    expect(@listener.last_roll_result[:knock_back_distance]).to eq(2)
   end
end

require 'rspec'
require 'entropy'
require 'dice_test_helpers'
require 'random_aarn_race'

class AarnRaceListenerFake
  attr_reader :race
  def initialize
    @race = ''
  end
  
  def your_race_is(race)
    @race = race
  end
end

RSpec.describe AarnRace do
  it 'uses to_s to output the race it was created with' do
    expect(AarnRace.new("Human").to_s).to eq("Human")
  end

  it 'allows embedding of suffixes and selects one' do
    Entropy::RANDOMIZER = RandomFake.new
    Entropy::RANDOMIZER.return_chain = [0]
    expect(AarnRace.new('Jerolan %{random}', ["Human"]).to_s).to eq("Jerolan Human")
  end

  it 'selects those suffixes randomly' do
    Entropy::RANDOMIZER = RandomFake.new
    Entropy::RANDOMIZER.return_chain = [1]
    expect(AarnRace.new('Jerolan %{random}', ["Human", "Ardlin"]).to_s).to eq("Jerolan Ardlin")
  end
end

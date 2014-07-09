require 'rspec'
require 'entropy'
require 'random_aarn_race'

RSpec.describe RandomAarnRace do
  before :each do
    Entropy::RANDOMIZER = RandomFake.new
    @listener = AarnRaceListenerFake.new
  end

  it 'selects a name from a list of names based on a dice roll' do
    Entropy::RANDOMIZER.return_chain = [0]
    RandomAarnRace.new(@listener).execute
    expect(@listener.name).to eq("")
  end
end

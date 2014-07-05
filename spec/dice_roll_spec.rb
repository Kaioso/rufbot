require 'rspec'
require 'entropy'
require 'dice_roll'
require 'dice_test_helpers'

RSpec.describe DiceRoll do
  before :each do
    Entropy::RANDOMIZER = RandomFake.new
    @listener = DiceRollListenerFake.new
    @rolls = []
    @total = 0
  end
  
  def roll_dice(params)
    DiceRoll.new(@listener, params).execute
    @rolls, @total = @listener.last_roll_result.values_at :rolls, :total
  end

  
  it 'asks for a random number up to the given maximum inlusive' do
    roll_dice({sides: 6})
    expect(Entropy::RANDOMIZER.last_called_range_max).to eq(6)
  end

  it 'passes the roll result to the listener' do
    Entropy::RANDOMIZER.number_to_return = 19
    roll_dice({sides: 20})
    expect([@rolls, @total]).to eq([[20], 20])
  end

  it 'can handle rolling several dice' do
    roll_dice({sides: 20, rolls: 2})
    expect([@rolls, @total]).to eq([[1, 1], 2])
  end

  it 'can take a modifier to add to the result' do
    roll_dice({sides: 20, result_modifier: 5})
    expect(@total).to eq(6)
  end

  it 'can take a modifier and add it to each roll' do
    roll_dice({sides: 20, rolls: 2, per_roll_modifier: 3})
    expect(@total).to eq(8)
  end

  # modifiers should be integral
end

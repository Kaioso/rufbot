require 'rspec'
require 'point_buy_value'

RSpec.describe PointBuyValue do
  before :each do
    @listener = PointBuyValueListenerFake.new
  end
  
  it 'gives a single value less equal to one one point' do
    PointBuyValue.new(@listener, [1]).execute
    expect(@listener.value).to eq(1)
  end

  it 'gives a series of numbers up to 6 one point each' do
    PointBuyValue.new(@listener, (1..6).to_a).execute
    expect(@listener.value).to eq(6)
  end

  it 'gives a single value of 7 two points' do
    PointBuyValue.new(@listener, [7]).execute
    expect(@listener.value).to eq(2)
  end

  it 'gives a series of numbers 7 to 8 2 points each' do
    PointBuyValue.new(@listener, [7, 8]).execute
    expect(@listener.value).to eq(4)
  end
end


class PointBuyValueListenerFake
  attr_reader :value
  def total_value(n)
    @value = n
  end
end

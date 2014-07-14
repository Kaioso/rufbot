require 'rspec'
require 'point_buy_value'

RSpec.describe PointBuyValue do
  before :each do
    @listener = PointBuyValueListenerFake.new
  end
  
  it 'gives a single value of nine a single point' do
    PointBuyValue.new(@listener, [9]).execute
    expect(@listener.value).to eq(1)
  end

  it 'gives a single value of ten two points' do
    PointBuyValue.new(@listener, [10]).execute
    expect(@listener.value).to eq(2)
  end

  it 'gives an empty list a value of zero' do
    PointBuyValue.new(@listener, []).execute
    expect(@listener.value).to eq(0)
  end

  it 'gives a single value of fifteen 8 points' do
    PointBuyValue.new(@listener, [15]).execute
    expect(@listener.value).to eq(8)
  end

  it 'gives a single value of sixteen 10 points' do
    PointBuyValue.new(@listener, [16]).execute
    expect(@listener.value).to eq(10)
  end

  it 'gives a single value of seventeen 13 points' do
    PointBuyValue.new(@listener, [17]).execute
    expect(@listener.value).to eq(13)
  end

  it 'gives a single value of eighteen 16 points' do
    PointBuyValue.new(@listener, [18]).execute
    expect(@listener.value).to eq(16)
  end

  it 'values multiple scores' do
    PointBuyValue.new(@listener, [18, 18]).execute
    expect(@listener.value).to eq(32)
  end

  it 'gives values at or below eight 0 points' do
    PointBuyValue.new(@listener, [8, 5]).execute
    expect(@listener.value).to eq(0)
  end

  it 'values scores higher than 18 as an 18' do
    PointBuyValue.new(@listener, [20, 55]).execute
    expect(@listener.value).to eq(32)
  end
end


class PointBuyValueListenerFake
  attr_reader :value
  def total_value(n)
    @value = n
  end
end

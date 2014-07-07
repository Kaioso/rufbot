class RandomFake
  attr_reader :ranges_given, :last_called_range_max, :roll_result
  attr_accessor :number_to_return
  attr_accessor :return_chain
  
  def initialize(number_to_return=0)
    @last_called_range_max = nil
    @ranges_given = []
    @number_to_return = number_to_return
    @roll_result = nil
    @return_chain = []
  end

  def rand(n)
    @last_called_range_max = n
    @ranges_given << n
    return return_chain.shift unless return_chain.empty?
    return @number_to_return
  end
end

class DiceRollListenerFake
  attr_reader :last_roll_result

  def show_roll_result(n)
    @last_roll_result = n
  end
end

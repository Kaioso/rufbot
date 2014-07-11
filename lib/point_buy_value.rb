class PointBuyValue
  def initialize(listener, values)
    @listener = listener
    @values = values
  end

  def execute
    @listener.total_value(@values.inject(0) do |memo, n|
                            memo + case n
                                   when [1..6] then 1
                                   when [7..8] then 2
                                   end
                          end)
  end
end

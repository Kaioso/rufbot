class PointBuyValue
  def initialize(listener, values)
    @listener = listener
    @values = values
  end

  def execute
    total = @values.inject(0, &self.method(:value_score))
    @listener.total_value(total)
  end

  private

  def value_score(total, score)
    purchased_numbers = (1..([18, score].min - 8)).to_a
    total + purchased_numbers.inject(0, &self.method(:score_breakdown))
  end

  def score_breakdown(total, n)
    total + case n
            when 1..6 then 1
            when 7..8 then 2
            when 9..10 then 3
            end
  end
end

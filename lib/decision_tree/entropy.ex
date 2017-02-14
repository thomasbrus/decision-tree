defmodule DecisionTree.Entropy do
  import DecisionTree.Frequency, only: [histogram: 1]

  def calculate(values) do
    Enum.reduce histogram(values), 0, fn({_, frequency}, entropy) ->
      relative_frequency = frequency / length(values)
      entropy - relative_frequency * :math.log2(relative_frequency)
    end
  end
end

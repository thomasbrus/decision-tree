defmodule DecisionTree.Frequency do
  def histogram(values) do
    Enum.reduce(values, %{}, fn(value, histogram) ->
      frequency = Map.get(histogram, value, 0) + 1
      Map.put(histogram, value, frequency)
    end)
  end
end

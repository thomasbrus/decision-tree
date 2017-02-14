defmodule DecisionTree.Frequency do
  def histogram(values) do
    Enum.reduce values, %{}, fn(value, histogram) ->
      frequency = Map.get(histogram, value, 0)
      Map.put(histogram, value, frequency + 1)
    end
  end

  def most_frequent_value(values) do
    histogram(values)
    |> Enum.max_by(&(elem(&1, 1)))
    |> elem(0)
  end
end

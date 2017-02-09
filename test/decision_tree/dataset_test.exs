defmodule DecisionTree.DatasetTest do
  use ExUnit.Case

  alias DecisionTree.Dataset

  doctest DecisionTree

  # http://www2.cs.uregina.ca/~dbd/cs831/notes/ml/dtrees/c4.5/c4.5_prob1.html
  # http://www.onlamp.com/pub/a/python/2006/02/09/ai_decision_trees.html

  @headers [
    :outlook, :temperature, :humidity, :windy, :advice
  ]

  @rows [
    ["sunny",     85,  85,  false,  :do_not_play],
    ["sunny",     80,  90,  true,   :do_not_play],
    ["overcast",  83,  78,  false,  :play],
    ["rain",      70,  96,  false,  :play],
    ["rain",      68,  80,  false,  :play],
    ["rain",      65,  70,  true,   :do_not_play],
    ["overcast",  64,  65,  true,   :play],
    ["sunny",     72,  95,  false,  :do_not_play],
    ["sunny",     69,  70,  false,  :play],
    ["rain",      75,  80,  false,  :play],
    ["sunny",     75,  70,  true,   :play],
    ["overcast",  72,  90,  true,   :play],
    ["overcast",  81,  75,  false,  :play],
    ["rain",      71,  80,  true,   :do_not_play]
  ]

  @data Enum.map(@rows, fn(row) ->
    Enum.zip(@headers, row) |> Enum.into(%{})
  end)

  test "split/3 splits the dataset based on an attribute and value" do
    dataset = Dataset.new(@data)

    {left_split, right_split} = Dataset.split(dataset, :outlook, "sunny")

    assert length(left_split.instances) == 5
    assert length(right_split.instances) == 9

    {left_split, right_split} = Dataset.split(dataset, :temperature, 80)

    assert length(left_split.instances) == 10
    assert length(right_split.instances) == 4
  end

  test "information_gain_split/2 splits the dataset by maximizing the information gain" do
    dataset = Dataset.new(@data)

    {left_split, _} = Dataset.information_gain_split(dataset, :advice)

    assert Enum.all?(left_split.instances, &(&1.outlook == "overcast"))
    assert Enum.all?(left_split.instances, &(&1.advice == :play))
  end

  test "percentage_split/2 splits the dataset percentage-wise" do
    dataset = Dataset.new(@data)

    {left_split, right_split} = Dataset.percentage_split(dataset, 6/7)

    assert length(left_split.instances) == 12
    assert length(right_split.instances) == 2
  end

  test "entropy/2 returns the entropy of a dataset" do
    dataset = Dataset.new(@data)
    assert_in_delta Dataset.entropy(dataset, :advice), 0.94029, 0.00001
  end

  test "homogeneous?/2 returns true when the dataset contains one instance" do
    dataset = @data |> Enum.take(1) |> Dataset.new
    assert Dataset.homogeneous?(dataset, :advice)
  end

  test "homogeneous?/2 returns true when the dataset contains instances from one class only" do
    dataset = @data |> Enum.filter(&(&1.advice == :play)) |> Dataset.new
    assert Dataset.homogeneous?(dataset, :advice)
  end

  test "homogeneous?/2 returns false when the dataset contains instances from multiple classes" do
    dataset = Dataset.new(@data)
    refute Dataset.homogeneous?(dataset, :advice)
  end

  test "histogram/2 retuns a map of attribute values and their frequencies" do
    histogram = @data |> Dataset.new |> Dataset.histogram(:outlook)
    assert histogram == %{"sunny" => 5, "overcast" => 4, "rain" => 5}
  end
end

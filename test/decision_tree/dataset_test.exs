defmodule DecisionTree.DatasetTest do
  use ExUnit.Case

  alias DecisionTree.Dataset

  doctest DecisionTree.Dataset

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

  @instances Enum.map(@rows, fn(row) ->
    Enum.zip(@headers, row) |> Enum.into(%{})
  end)

  @dataset Dataset.new(@instances, :advice)

  test "split/3 splits the dataset based on an attribute and value" do
    {left_dataset, right_dataset} = Dataset.split(@dataset, :outlook, "sunny")

    assert length(left_dataset.instances) == 5
    assert length(right_dataset.instances) == 9

    {left_dataset, right_dataset} = Dataset.split(@dataset, :temperature, 80)

    assert length(left_dataset.instances) == 10
    assert length(right_dataset.instances) == 4
  end

  test "optimal_split/2 finds the optimal split according to the given evaluation method" do
    optimal_split = Dataset.optimal_split(@dataset, &Dataset.information_gain/3)
    assert optimal_split == {:outlook, "overcast"}
  end

  # test "information_gain_split/2 splits the dataset by maximizing the information gain" do
  #   dataset = Dataset.new(@data)

  #   {left_dataset, _} = Dataset.information_gain_split(dataset, :advice)

  #   # assert Enum.all?(left_dataset.instances, &(&1.outlook == "overcast"))
  #   assert Enum.all?(left_dataset.instances, &(&1.advice == :play))
  # end

  test "percentage_split/2 splits the dataset percentage-wise" do
    {left_dataset, right_dataset} = Dataset.percentage_split(@dataset, 6/7)

    assert length(left_dataset.instances) == 12
    assert length(right_dataset.instances) == 2
  end

  test "entropy/2 returns the entropy of a dataset" do
    entropy = Dataset.entropy(@dataset)
    assert_in_delta entropy, 0.94029, 0.00001
  end

  test "information_gain/2 returns the gain in entropy when splitting on a certain attribute" do
    gain = Dataset.information_gain(@dataset, :outlook, "overcast")
    assert_in_delta gain, 0.22600, 0.00001
  end

  test "homogeneous?/2 is not implemented for empty datasets" do
    assert_raise FunctionClauseError, fn ->
      %{@dataset | instances: []} |> Dataset.homogeneous?
    end
  end

  test "homogeneous?/2 returns true when the dataset contains one instance" do
    dataset = %{@dataset | instances: Enum.take(@instances, 1)}
    assert Dataset.homogeneous?(dataset)
  end

  test "homogeneous?/2 returns true when the dataset contains instances from one class only" do
    dataset = %{@dataset | instances: Enum.filter(@instances, &(&1.advice == :play))}
    assert Dataset.homogeneous?(dataset)
  end

  test "homogeneous?/2 returns false when the dataset contains instances from multiple classes" do
    refute Dataset.homogeneous?(@dataset)
  end

  test "histogram/2 retuns a map of attribute values and their frequencies" do
    histogram = Dataset.histogram(@dataset, :outlook)
    assert histogram == %{"sunny" => 5, "overcast" => 4, "rain" => 5}
  end

  test "attributes/1 returns the attributes of a dataset" do
    attributes = Dataset.attributes(@dataset)
    assert attributes == [:humidity, :outlook, :temperature, :windy]
  end

  test "majority_class/2 returns the most frequent class in the dataset" do
    class = Dataset.majority_class(@dataset)
    assert class == :play
  end
end

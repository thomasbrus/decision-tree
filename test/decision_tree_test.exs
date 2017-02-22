defmodule DecisionTreeTest do
  use ExUnit.Case

  alias DecisionTree.Dataset

  doctest DecisionTree

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

  test "classify/2 returns the class corresponding to a test instance according to the tree" do
    decision_tree = DecisionTree.build(@dataset)

    test_instance1 = %{outlook: "sunny", temperature: 75, humidity: 70, windy: false}
    test_instance2 = %{outlook: "rain", temperature: 70, humidity: 90, windy: true}

    assert DecisionTree.classify(decision_tree, test_instance1) == :play
    assert DecisionTree.classify(decision_tree, test_instance2) == :do_not_play
  end
end

alias DecisionTree
alias DecisionTree.Dataset

headers = [
  :outlook, :temperature, :humidity, :windy, :advice
]

rows = [
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

instances = Enum.map rows, fn(row) ->
  Enum.zip(headers, row) |> Enum.into(%{})
end

dataset = %Dataset{instances: instances, class_attribute: :advice}

decision_tree = DecisionTree.build(dataset)

Enum.each instances, fn(instance) ->
  prediction = DecisionTree.classify(decision_tree, instance)
  IO.puts "#{inspect(instance)} => #{prediction}"
end

defmodule DecisionTree.Dataset do
  alias __MODULE__, as: Dataset
  alias DecisionTree.Frequency

  defstruct [:instances]

  def new(instances) do
    %Dataset{instances: instances}
  end

  def split(%Dataset{} = dataset, attribute, value) when is_binary(value) or is_boolean(value) do
    split(dataset, fn(instance) -> Map.fetch!(instance, attribute) == value end)
  end

  def split(%Dataset{} = dataset, attribute, value) when is_number(value) do
    split(dataset, fn(instance) -> Map.fetch!(instance, attribute) < value end)
  end

  def split(%Dataset{instances: instances}, fun) when is_function(fun) do
    {instances1, instances2} = Enum.split_with(instances, fun)
    {new(instances1), new(instances2)}
  end

  def information_gain_split(%Dataset{instances: [instance | _]} = dataset, class_attribute) do
    candidate_attributes = Map.keys(instance) |> List.delete(class_attribute)

    split_attributes_and_values = Enum.flat_map(candidate_attributes, fn(split_attribute) ->
      unique_values(dataset, split_attribute) |> Enum.map(&({split_attribute, &1}))
    end)

    {split_attribute, split_value} = Enum.max_by(split_attributes_and_values, fn({split_attribute, split_value}) ->
      Dataset.information_gain(dataset, class_attribute, split_attribute, split_value)
    end)

    split(dataset, split_attribute, split_value)
  end

  def percentage_split(%Dataset{instances: instances} = dataset, ratio) when is_float(ratio) do
    percentage_split(dataset, round(Enum.count(instances) * ratio))
  end

  def percentage_split(%Dataset{instances: instances}, count) when is_integer(count) do
    {instances1, instances2} = Enum.shuffle(instances) |> Enum.split(count)
    {new(instances1), new(instances2)}
  end

  def entropy(%Dataset{instances: instances} = dataset, class_attribute) do
    histogram(dataset, class_attribute) |> Enum.reduce(0, fn({_, frequency}, entropy) ->
      relative_frequency = frequency / length(instances)
      entropy - relative_frequency * :math.log2(relative_frequency)
    end)
  end

  def information_gain(%Dataset{} = dataset, class_attribute, split_attribute, split_value) do
    subsets = split(dataset, split_attribute, split_value) |> Tuple.to_list

    entropy_after_split = Enum.reduce(subsets, 0, fn(subset, total) ->
      total + ratio(subset, dataset) * entropy(subset, class_attribute)
    end)

    entropy(dataset, class_attribute) - entropy_after_split
  end

  def homogeneous?(%Dataset{instances: [_instance]}, _class_attribute) do
    true
  end

  def homogeneous?(%Dataset{} = dataset, class_attribute) do
    (unique_values(dataset, class_attribute) |> length) == 1
  end

  def histogram(%Dataset{} = dataset, attribute) do
    values(dataset, attribute) |> Frequency.histogram
  end

  defp values(%Dataset{instances: instances}, attribute) do
    Enum.map(instances, &(Map.fetch!(&1, attribute)))
  end

  defp unique_values(%Dataset{} = dataset, attribute) do
    values(dataset, attribute) |> Enum.uniq
  end

  defp ratio(%Dataset{instances: instances1}, %Dataset{instances: instances2}) do
    length(instances1) / length(instances2)
  end
end

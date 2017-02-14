defmodule DecisionTree.Dataset do
  alias __MODULE__, as: Dataset
  alias DecisionTree.{Frequency,Entropy}

  @enforce_keys [:instances, :class_attribute]
  defstruct [:instances, :class_attribute]

  def split(%Dataset{} = dataset, attribute, value) when is_number(value) do
    split(dataset, fn(instance) -> Map.fetch!(instance, attribute) < value end)
  end

  def split(%Dataset{} = dataset, attribute, value) when is_binary(value) or is_boolean(value) do
    split(dataset, fn(instance) -> Map.fetch!(instance, attribute) == value end)
  end

  def split(%Dataset{instances: instances} = dataset, fun) when is_function(fun) do
    {instances1, instances2} = Enum.split_with(instances, fun)
    {%{dataset | instances: instances1}, %{dataset | instances: instances2}}
  end

  def percentage_split(%Dataset{instances: instances} = dataset, ratio) when is_float(ratio) do
    percentage_split(dataset, round(Enum.count(instances) * ratio))
  end

  def percentage_split(%Dataset{instances: instances} = dataset, count) when is_integer(count) do
    {instances1, instances2} = Enum.shuffle(instances) |> Enum.split(count)
    {%{dataset | instances: instances1}, %{dataset | instances: instances2}}
  end

  def optimal_split(%Dataset{} = dataset, evaluation_method) do
    candidates = attributes(dataset) |> Enum.flat_map(fn(split_attribute) ->
      unique_values(dataset, split_attribute) |> Enum.map(&({split_attribute, &1}))
    end)

    Enum.max_by(candidates, fn({split_attribute, split_value}) ->
      evaluation_method.(dataset, split_attribute, split_value)
    end)
  end

  def entropy(%Dataset{class_attribute: class_attribute} = dataset) do
    dataset |> values(class_attribute) |> Entropy.calculate
  end

  def information_gain(%Dataset{} = dataset, split_attribute, split_value) do
    subsets = split(dataset, split_attribute, split_value) |> Tuple.to_list

    entropy_after_split = Enum.reduce(subsets, 0, fn(subset, total) ->
      total + ratio(subset, dataset) * entropy(subset)
    end)

    entropy(dataset) - entropy_after_split
  end

  def homogeneous?(%Dataset{instances: [_instance]}) do
    true
  end

  def homogeneous?(%Dataset{instances: [_instance | _]} = dataset) do
    (dataset |> unique_values(dataset.class_attribute) |> length) == 1
  end

  def histogram(%Dataset{} = dataset, attribute) do
    values(dataset, attribute) |> Frequency.histogram
  end

  def majority_class(%Dataset{class_attribute: class_attribute} = dataset) do
    values(dataset, class_attribute) |> Frequency.most_frequent_value
  end

  def remove_attribute(%Dataset{instances: instances} = dataset, attribute) do
    %{dataset | instances: Enum.map(instances, &Map.delete(&1, attribute))}
  end

  def attributes(%Dataset{instances: [instance | _]} = dataset) do
    Map.keys(instance) |> List.delete(dataset.class_attribute)
  end

  def values(%Dataset{instances: instances}, attribute) do
    Enum.map(instances, &(Map.fetch!(&1, attribute)))
  end

  def class_values(%Dataset{class_attribute: class_attribute} = dataset) do
    values(dataset, class_attribute)
  end

  defp unique_values(%Dataset{} = dataset, attribute) do
    values(dataset, attribute) |> Enum.uniq
  end

  defp ratio(%Dataset{instances: instances1}, %Dataset{instances: instances2}) do
    length(instances1) / length(instances2)
  end
end

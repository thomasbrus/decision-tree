defmodule DecisionTree.Tree do
  def leaf(class) do
    {:leaf, class}
  end

  def node(split_attribute, split_value, left, right) do
    {:node, split_attribute, split_value, left, right}
  end

  def traverse({:leaf, _class} = leaf, _instance) do
    leaf
  end

  def traverse({:node, split_attribute, split_value, left, right}, instance) when is_number(split_value) do
    case instance[split_attribute] < split_value do
      true -> traverse(left, instance)
      false -> traverse(right, instance)
    end
  end

  def traverse({:node, split_attribute, split_value, left, right}, instance) do
    case instance[split_attribute] == split_value do
      true -> traverse(left, instance)
      false -> traverse(right, instance)
    end
  end
end

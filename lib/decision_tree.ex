defmodule DecisionTree do
  defstruct [:root]

  # https://github.com/yosriady/decision_tree/blob/master/lib/decision_tree.ex
  # https://github.com/lagodiuk/decision-tree-js/blob/master/decision-tree.js
  # http://scikit-learn.org/stable/modules/tree.html

  alias __MODULE__, as: DecisionTree
  alias DecisionTree.{Dataset, Tree}

  def load(_filename) do
    # File.read |> Decoder.decode(...)
    # defimpl DecisionTree.Decoder, for: Node
  end

  def save(%DecisionTree{} = _decision_tree, _filename) do
    # Encoder.encode(decision_tree) |> File.write(filename)
    # defimpl DecisionTree.Encoder, for: Node
  end

  def build(%Dataset{} = training_set) do
    training_set |> train |> prune
  end

  def train(%Dataset{instances: []}) do
    raise ArgumentError, message: "cannot build decision tree on empty dataset"
  end

  def train(%Dataset{instances: [instance], class_attribute: class_attribute}) do
    %DecisionTree{root: Map.fetch!(instance, class_attribute) |> Tree.leaf}
  end

  def train(%Dataset{} = training_set) do
    %DecisionTree{root: cond do
      Dataset.homogeneous?(training_set) ->
        Dataset.class_values(training_set) |> hd |> Tree.leaf

      Dataset.attributes(training_set) == [] ->
        Dataset.majority_class(training_set) |> Tree.leaf

      true ->
        # Split dataset so that optimal information gain is achieved
        {split_attribute, split_value} =
          Dataset.optimal_split(training_set, &Dataset.information_gain/3)

        {left_dataset, right_dataset} =
          Dataset.split(training_set, split_attribute, split_value)

        # Remove split attribute so that it is not used again
        left_dataset = Dataset.remove_attribute(left_dataset, split_attribute)
        right_dataset = Dataset.remove_attribute(right_dataset, split_attribute)

        {left_tree, right_tree} = {build(left_dataset), build(right_dataset)}

        Tree.node(split_attribute, split_value, left_tree.root, right_tree.root)
    end}
  end

  def classify(%DecisionTree{root: root}, %{} = instance) do
    {:leaf, class} = Tree.traverse(root, instance)
    class
  end

  def prune(%DecisionTree{} = decision_tree) do
    %{decision_tree | root: Tree.prune(decision_tree)}
  end
end

defmodule DecisionTree.Tree do
  alias DecisionTree.Tree.{Leaf,Node}

  def leaf(class) do
    Leaf.new(class)
  end

  def node(split_attribute, split_value, left, right) do
    Node.new(split_attribute, split_value, left, right)
  end

  def traverse(%Leaf{} = leaf, _instance) do
    leaf
  end

  def traverse(%Node{split_value: split_value} = node, instance) when is_number(split_value) do
    case instance[node.split_attribute] < split_value do
      true -> traverse(node.left, instance)
      false -> traverse(node.right, instance)
    end
  end

  def traverse(%Node{split_value: split_value} = node, instance) do
    case instance[node.split_attribute] == split_value do
      true -> traverse(node.left, instance)
      false -> traverse(node.right, instance)
    end
  end

  def prune(tree) do
    tree
  end
end

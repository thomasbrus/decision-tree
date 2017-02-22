defmodule DecisionTree.Tree.Node do
  defstruct [:split_attribute, :split_value, :left, :right]

  def new(split_attribute, split_value, left, right) do
    %__MODULE__{
      split_attribute: split_attribute,
      split_value: split_value,
      left: left,
      right: right
    }
  end
end

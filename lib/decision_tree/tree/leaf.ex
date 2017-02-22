defmodule DecisionTree.Tree.Leaf do
  defstruct [:class]

  def new(class) do
    %__MODULE__{class: class}
  end
end

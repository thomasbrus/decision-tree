defmodule DecisionTree.Tree.Leaf do
  @enforce_keys [:class]
  defstruct [:class]

  def new(class) do
    %__MODULE__{class: class}
  end
end

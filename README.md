# DecisionTree

Decision tree in Elixir (work in progress)...

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `decision_tree` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:decision_tree, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/decision_tree](https://hexdocs.pm/decision_tree).

## Usage

```
CSV.read(examples/...)
```

## Features

- [x] Handles discrete and continuous attributes
- [x] No dependencies

# Todo
- [ ] Handling missing values
- [ ] Serialization from and to JSON
- [ ] Concurrency for speed improvements on large datasets
- [ ] Tree pruning

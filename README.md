# ElixirOC

To view the docs open 
```
doc/index.html
```

Running locally:
```
mix deps.get
touch config/dev.exs
```

In your config/dev.exs:
```
use Mix.Config

config :elixirOC, appID: "<appID>"
config :elixirOC, apikey: "<apikey>"
```

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `elixirOC` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:elixirOC, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/elixirOC](https://hexdocs.pm/elixirOC).


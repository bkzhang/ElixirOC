defmodule ElixirOC do

  @doc """
  Returns a map of all the route summaries of the requested bus stops.

  ## Examples

      iex> bus_stops = [7659, 3060] 
      iex> ElixirOC,bus_routes_list(bus_stops)

  """
  def bus_routes_list(bus_stops) do
    coordinator_pid = spawn(ElixirOC.Coordinator, :loop, [[], Enum.count(bus_stops)])

    bus_stops
    |> Enum.each(fn bus_stop ->
      worker_pid = spawn(ElixirOC.Worker, :loop, [])
      send worker_pid, {coordinator_pid, bus_stop}
    end)
  end
end

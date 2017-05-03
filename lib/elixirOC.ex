defmodule ElixirOC do

  def bus_routes_list(bus_stops) do
    coordinator_pid = spawn(ElixirOC.Coordinator, :loop, [[], Enum.count(bus_stops)])

    bus_stops
    |> Enum.each(fn bus_stop ->
      worker_pid = spawn(ElixirOC.Worker, :loop, [])
      send worker_pid, {coordinator_pid, bus_stop}
    end)
  end
end

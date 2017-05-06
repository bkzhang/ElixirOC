defmodule ElixirOC do
  @moduledoc """
  Manages the workers and coordinator.
  """

  @doc """
  Spawns coordinator and worker processes and sends the coordinator pid to the spawned workers.
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

defmodule ElixirOC do
  @moduledoc """
  Manages the workers and coordinator.
  """

  @doc """
  Spawns coordinator and worker processes and sends the coordinator pid to the spawned workers and later receives all the work done by the worker and coordinator. 

  ## Examples

      iex> routes = [7659, {3060, 16}]
      iex> ElixirOC.bus_routes_list(routes)
      %{3060 => %{16 => "Britannia"},
        7659 => %{1 => "Ottawa-Rockcliffe", 7 => "St-Laurent"}}

  """
  @spec bus_routes_list(list) :: map 
  def bus_routes_list(bus_stops) do
    coordinator_pid = spawn(ElixirOC.Coordinator, :loop, [{%{}, 0, Enum.count(bus_stops), self()}])

    bus_stops
    |> Enum.each(fn bus_stop ->
         worker_pid = spawn(ElixirOC.Worker, :loop, [])
         send worker_pid, {coordinator_pid, bus_stop}
       end)
    receive do
      {:done, results} -> 
        results
      _ ->
        IO.puts :error 
    end
  end
end

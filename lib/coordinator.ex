defmodule ElixirOC.Coordinator do
  @moduledoc """
  Gathers the result of all the worker processes and prints out the sorted list of bus route summaries.
  """

  @doc """
  Continuously loops until it receives the requested amount of bus route summaries and prints out a list tuple by tuple. 
  """
  def loop(results \\ [], expected) do
    receive do
      {:ok, result, bus_stop, route} ->
        List.keystore(results, bus_stop, 0, {String.to_atom(Integer.to_string(bus_stop)), {route, result}})
        |> exit_loop(expected)
        |> loop(expected)
      {:ok, result, bus_stop} ->
        List.keystore(results, bus_stop, 0, {String.to_atom(Integer.to_string(bus_stop)), result})
        |> exit_loop(expected)
        |> loop(expected)
      :exit ->
        Enum.sort(results)
        |> Enum.each(fn r ->
            IO.inspect r
           end)
      _ ->
        loop(results, expected)
    end
  end

  defp exit_loop(results, expected) do
    if Enum.count(results) == expected do
      send self(), :exit
    end
    results
  end
end

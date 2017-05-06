defmodule ElixirOC.Coordinator do
  @moduledoc """
  Gathers the result of all the worker processes and prints out the sorted list of bus route summaries.
  """

  @doc """
  Continuously loops until it receives the requested amount of bus route summaries and prints it out as a list.
  """
  def loop(results \\ [], expected) do
    receive do
      {:ok, result, bus_stop, route} ->
        new_results = List.keystore(results, bus_stop, 0, {String.to_atom(Integer.to_string(bus_stop)), {route, result}})
        exit_loop(new_results, expected)
        loop(new_results, expected)
      {:ok, result, bus_stop} ->
        new_results = List.keystore(results, bus_stop, 0, {String.to_atom(Integer.to_string(bus_stop)), result})
        exit_loop(new_results, expected)
        loop(new_results, expected)
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
  end
end

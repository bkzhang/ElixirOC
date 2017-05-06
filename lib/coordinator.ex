defmodule ElixirOC.Coordinator do
  @moduledoc """
  Gathers the result of all the worker processes and prints out the sorted list of bus route summaries.
  """

  @doc """
  Continuously loops until it receives the requested amount of bus route summaries and prints out a list tuple by tuple. 
  """
  def loop({results, expected, main_pid}) do
    receive do
      {:ok, result, bus_stop, route} ->
        {List.keystore(results, bus_stop, 0, {String.to_atom(Integer.to_string(bus_stop)), {route, result}}), expected, main_pid}
        |> exit_loop
        |> loop
      {:ok, result, bus_stop} ->
        {List.keystore(results, bus_stop, 0, {String.to_atom(Integer.to_string(bus_stop)), result}), expected, main_pid}
        |> exit_loop
        |> loop
      {:exit, main_pid} ->
        Enum.sort(results)
        |> Enum.each(fn r ->
            IO.inspect r
           end) 
        send main_pid, :done
      _ ->
        loop {results, expected, main_pid}
    end
  end

  defp exit_loop({results, expected, main_pid}) do
    if Enum.count(results) == expected do
      send self(), {:exit, main_pid}
    end
    {results, expected, main_pid}
  end
end

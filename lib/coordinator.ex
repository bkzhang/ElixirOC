defmodule ElixirOC.Coordinator do
  @moduledoc """
  Gathers the result of all the worker processes into a single map. 
  """

  @doc """
  Continuously loops until it receives the requested amount of bus route summaries and sends it to the main process as a map. 
  """
  def loop({results, iterations, expected, main_pid}) do
    receive do
      {:ok, result, bus_stop, route} ->
        {Map.put_new(results, bus_stop, %{route => result}), iterations+1, expected, main_pid}
        |> exit_loop
        |> loop
      {:ok, result, bus_stop} ->
        {Enum.reduce(result, results, fn _, acc ->
          Map.put_new(acc, bus_stop, Map.new(result))
        end), iterations+1, expected, main_pid} 
        |> exit_loop
        |> loop
      {:exit, main_pid} ->
        send main_pid, {:done, results}
      _ ->
        loop {results, iterations, expected, main_pid}
    end
  end

  defp exit_loop({results, iterations, expected, main_pid}) do
    if iterations == expected do
      send self(), {:exit, main_pid}
    end
    {results, iterations, expected, main_pid}
  end
end

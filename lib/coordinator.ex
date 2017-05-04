defmodule ElixirOC.Coordinator do
  
  def loop(results \\ %{}, expected) do
    receive do
      {:ok, result, bus_stop} ->
        #new_results -> :ok here
        new_results = Enum.reduce(result, %{}, fn r, acc ->
          Map.put(acc, bus_stop, r)
        end)
        if expected == Enum.count(new_results) do
          send self(), :exit
        end
        loop(new_results, expected)
      :exit ->
        #Enum.each(results, fn v -> IO.puts(Map.values(v)) end)
        IO.puts(results)
      _ ->
        loop(results, expected)
    end
  end
end

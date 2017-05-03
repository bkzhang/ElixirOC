defmodule ElixirOC.Coordinator do
  
  def loop(results \\ [], expected) do
    receive do
      {:ok, result} ->
        new_results = [result|results]
        if expected == Enum.count(new_results) do
          send self(), :exit
        end
        loop(new_results, expected)
      :exit ->
        Enum.each(results, fn v -> IO.puts(Map.values(v)) end)
      _ ->
        loop(results, expected)
    end
  end
end

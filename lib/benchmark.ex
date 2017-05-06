defmodule Benchmark do
  @moduledoc """
  Speedtest of multiple processes vs a single process.
  """

  @doc """
  Compares single process speed vs multiple processes
  """
  @spec run(integer) :: atom
  def run(number) do 
    list = Stream.cycle([3060])
           |> Enum.take(number)
    IO.puts "Making #{number} requests through 200 processes"
    multi = 
      time(fn -> ElixirOC.bus_routes_list(list) end) 
    
    IO.puts "Making #{number} requests through 1 process"
    single = 
      time(fn -> Enum.each(1..number, fn _ -> ElixirOC.Worker.route_summary(3060) |> IO.inspect end) end)

    IO.puts "Multiple processes time: #{multi}"
    IO.puts "Single process time:     #{single}"
    IO.puts "Single - Multi: #{single - multi}"
    :done
  end

  defp time(func) do
    func
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end

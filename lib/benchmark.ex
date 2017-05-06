defmodule Benchmark do
  @moduledoc """
  Speedtest of multiple processes vs a single process.
  """

  def run do 
    IO.puts "Making 200 requests through 200 processes"
    list = Stream.cycle([3060])
           |> Enum.take(200)
    multi = time(fn -> ElixirOC.bus_routes_list(list) end) 
    
    IO.puts "Making 200 requests through 1 process"
    single = time(fn -> Enum.each(1..200, fn _ -> 
                          ElixirOC.Worker.route_summary(3060) 
                          |> IO.inspect
                        end)
                  end) 

    IO.puts "Multiple processes time: #{multi}"
    IO.puts "Single process time:     #{single}"
    IO.puts "Single - Multi: #{single - multi}"
  end

  def time(func) do
    func
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end

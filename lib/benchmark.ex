defmodule Benchmark do
  @moduledoc """
  Speedtest of multiple processes vs a single process.
  """

  @doc """
  Compares single process speed vs multiple processes.
  """
  @spec run(integer) :: :ok 
  def run(number) do 
    IO.puts "Making #{number} requests through #{number} processes"
    multi = multiple_processes(number) 
    
    IO.puts "Making #{number} requests through 1 process"
    single = single_process(number) 

    IO.puts "Multiple processes time: #{multi}"
    IO.puts "Single process time:     #{single}"
    IO.puts "Single - Multiple:       #{single - multi}"
    try do 
      IO.puts "Multiple processes is #{div(round(single), round(multi))} times faster than a single process"
    rescue
      _ ->
        "Could not compute multiplicative speed comparison"
    end
    :ok
  end

  @doc """
  Speed tests for a single process.
  """
  @spec run_single(integer) :: :ok 
  def run_single(number) do
    IO.puts "Making #{number} requests through a single process."
    single = single_process(number)
    IO.puts "Single process time: #{single}"
    :ok
  end

  @doc """
  Speed tests for multiple processes.
  """
  @spec run_multiple(integer) :: :ok 
  def run_multiple(number) do
    IO.puts "Making #{number} requests through #{number} processes"
    multi = multiple_processes(number) 
    IO.puts "Multiple processes time: #{multi}"
    :ok
  end

  defp single_process(number) do
    time(fn -> Enum.each(1..number, fn _ -> ElixirOC.Worker.route_summary(3060) end) end)
  end

  defp multiple_processes(number) do
    list = Stream.cycle([3060])
           |> Enum.take(number)
    time(fn -> ElixirOC.bus_routes_list(list) end)
  end

  defp time(func) do
    func
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end

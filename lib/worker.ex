defmodule ElixirOC.Worker do
  @moduledoc """
  Worker that does all the requests.
  """

  @doc """
  Sends the requested information to the coordinator pid.
  """
  def loop do
    receive do
      {sender_pid, {bus_stop, route}} ->
        send(sender_pid, {:ok, route_summary(bus_stop, route), bus_stop, route})
      {sender_pid, bus_stop} ->
        send(sender_pid, {:ok, Enum.sort(route_summary(bus_stop)), bus_stop})
      _ ->
        IO.puts "Message unabled to be processed"
    end
    loop()
  end

  @doc """
  Returns a string of the final stop the bus is heading for of the requested bus stop and route number.

  ## Examples

      iex> ElixirOC.Worker.route_summary(7659, 1)
      "Ottawa-Rockcliffe" 

  """
  @spec route_summary(integer, integer) :: String.t 
  def route_summary(bus_stop, route_no) do
    bus_stop
    |> route_summary
    |> Map.get(route_no)
  end
  
  @doc """
  Returns a map of the route summary of the requested bus stop.

  ## Examples

      iex> ElixirOC.Worker.route_summary(7659)
      %{1 => "Ottawa-Rockcliffe", 7 => "St-Laurent"}

  """
  @spec route_summary(integer) :: {integer, String.t}
  def route_summary(bus_stop) do
    case request(bus_stop) do
      {:ok, routes} ->
        routes
        |> Enum.reduce(%{}, fn route, acc -> 
             Map.put(acc, route["RouteNo"], route["RouteHeading"]) 
           end) 
      :error ->
        "#{bus_stop} not found"
    end
  end

  defp request(bus_stop) do
    bus_stop
    |> route_url
    |> :httpc.request
    |> parse_resp
  end

  defp route_url(bus_stop) do
    'https://api.octranspo1.com/v1.2/GetRouteSummaryForStop?appID=#{appID()}&apiKey=#{apikey()}&stopNo=#{bus_stop}&format=json'
  end

  defp parse_resp({:ok, {status, _, body}}) do 
    { _, status_code, _ } = status
    case status_code do
      200 ->
        body 
        |> JSON.decode! 
        |> fetch_route
      _ ->
        :error
    end
  end

  defp parse_resp(_) do
    :error
  end

  defp fetch_route(json) do
    try do
      routes = json["GetRouteSummaryForStopResult"]["Routes"]["Route"]
      {:ok, routes}
    rescue
      _ ->
        :error
    end
  end  

  defp appID do
    Application.get_env(:elixirOC, :appID)
  end

  defp apikey do
    Application.get_env(:elixirOC, :apikey)
  end
end

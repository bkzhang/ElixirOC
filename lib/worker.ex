defmodule ElixirOC.Worker do
  @moduledoc """
  Worker that does all the requests.
  """

  @doc """
  Returns route summary of the requested bus stop.

  ## Examples

      iex> ElixirOC.Worker.route_summary(7659, 1)
      "Ottawa-Rockcliffe" 

  """
  def route_summary(bus_stop, route_no) do
    route_summary(bus_stop)
    |> Map.get(route_no)
  end
  
  def route_summary(bus_stop) do
    result = route_url(bus_stop)
             |> :httpc.request
             |> parse_resp
    case result do
      {:ok, routes} ->
        Enum.reduce(routes, %{}, fn route, acc -> Map.put(acc, route["RouteNo"], route["RouteHeading"]) end) 
      :error ->
        "#{bus_stop} not found"
    end
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

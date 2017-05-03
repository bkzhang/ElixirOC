defmodule ElixirOC.Worker do
  @moduledoc """
  Worker that does all the requests.
  """
  
  @doc """
  Returns route summary of the requested bus stop.

  ## Examples

      iex> ElixirOC.Worker.route_summary(7659)

  """
  def route_summary(bus_stop) do
    result = route_url(bus_stop)
             |> :httpc.request
             |> parse_res
    case result do
      {:ok, json} ->
        json
      :error ->
        "#{bus_stop} not found"
    end
  end

  defp route_url(bus_stop) do
    'https://api.octranspo1.com/v1.2/GetRouteSummaryForStop?appID=#{appID()}&apiKey=#{apikey()}&stopNo=#{bus_stop}&format=json'
  end

  defp parse_res({:ok, {status, _, body}}) do 
    {_, status_code, _} = status
    case status_code do
      200 ->
        body |> JSON.decode! |> fetch_route
      _ ->
        :error
    end
  end

  defp parse_res(_) do
    :error
  end

  defp fetch_route(json) do
    try do
      {:ok, json}
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

defmodule ElixirOCTest do
  use ExUnit.Case
  doctest ElixirOC
  doctest ElixirOC.Worker

  test "worker bus routes" do
    assert ElixirOC.Worker.route_summary(7687) == %{1 => "South Keys", 7 => "Carleton", 11 => "Bayshore", 9 => "Rideau", 12 => "Rideau"}
    assert ElixirOC.Worker.route_summary(3060, 62) == "Stittsville"
  end

  test "main process" do
    assert ElixirOC.bus_routes_list([7659]) == %{7659 => %{1 => "Ottawa-Rockcliffe", 7 => "St-Laurent"}}
    assert ElixirOC.bus_routes_list([{7687, 7}]) == %{7687 => %{7 => "Carleton"}}
    assert ElixirOC.bus_routes_list([7687, {7659, 1}]) == %{7659 => %{1 => "Ottawa-Rockcliffe"}, 7687 => %{1 => "South Keys", 7 => "Carleton", 11 => "Bayshore", 9 => "Rideau", 12 => "Rideau"}} 
  end
end

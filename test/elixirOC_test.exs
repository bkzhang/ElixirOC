defmodule ElixirOCTest do
  use ExUnit.Case
  doctest ElixirOC.Worker

  test "worker bus routes" do
    assert ElixirOC.Worker.route_summary(3352) == %{80 => "Barrhaven Centre", 277 => "Mackenzie King"}
    assert ElixirOC.Worker.route_summary(3060, 62) == "Stittsville"
  end
end

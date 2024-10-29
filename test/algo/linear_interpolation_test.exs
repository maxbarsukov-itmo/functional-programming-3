defmodule InterpolationApp.Algo.LinearInterpolationTest do
  @moduledoc """
  Testing InterpolationApp.Algo.LinearInterpolation
  """

  use ExUnit.Case, async: true
  use Quixir

  alias InterpolationApp.Algo.LinearInterpolation, as: Algo

  describe "get_name/0" do
    test "returns correct name" do
      assert Algo.get_name() == "Линейная интерполяция"
    end
  end

  describe "get_enough_points_count/0" do
    test "returns correct enough points count" do
      assert Algo.get_enough_points_count() == 2
    end
  end

  describe "interpolate/2" do
    test "calculates correct linear interpolation for 2 points" do
      points = [{1, 2}, {2, 4}]
      point = Algo.interpolate(points, 1.5)

      assert point == {1.5, 3.0}
    end

    test "linear interpolation returns tuple {x, y} with x as input" do
      ptest x: float(), p1: float(), p2: float() do
        points = [{1, p1}, {2, p2}]
        {result_x, _} = Algo.interpolate(points, x)
        result_x == x
      end
    end
  end
end

defmodule InterpolationApp.Algo.NewtonInterpolationTest do
  @moduledoc """
  Testing InterpolationApp.Algo.NewtonInterpolation
  """

  use ExUnit.Case, async: true
  use Quixir

  alias InterpolationApp.Algo.NewtonInterpolation, as: Algo

  describe "get_name/0" do
    test "returns correct name" do
      assert Algo.get_name() == "Интерполяция по Ньютону"
    end
  end

  describe "get_enough_points_count/0" do
    test "returns correct enough points count" do
      assert Algo.get_enough_points_count() == 2
    end
  end

  describe "interpolate/2" do
    test "calculates correct Newton interpolation for given points" do
      points = [{1, 1}, {2, 4}, {3, 9}, {4, 16}, {5, 25}]
      {x, y} = Algo.interpolate(points, 4.5)

      assert x == 4.5 and y > 17 and y < 22
    end

    test "Newton interpolation returns {x, y} with x matching input" do
      ptest x: float(), p1: float(), p2: float(), p3: float() do
        points = [{1, p1}, {2, p2}, {3, p3}]
        {result_x, _} = Algo.interpolate(points, x)
        result_x == x
      end
    end
  end
end

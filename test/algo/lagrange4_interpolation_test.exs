defmodule InterpolationApp.Algo.Lagrange4InterpolationTest do
  @moduledoc """
  Testing InterpolationApp.Algo.Lagrange4Interpolation
  """

  use ExUnit.Case, async: true
  use Quixir

  alias InterpolationApp.Algo.Lagrange4Interpolation, as: Algo

  describe "get_name/0" do
    test "returns correct name" do
      assert Algo.get_name() == "Интерполяционный многочлен Лагранжа для 4 точек"
    end
  end

  describe "get_enough_points_count/0" do
    test "returns correct enough points count" do
      assert Algo.get_enough_points_count() == 4
    end
  end

  describe "interpolate/2" do
    test "calculates correct interpolation for 4 points" do
      points = [{1, 1}, {2, 4}, {3, 9}, {4, 16}]
      point = Algo.interpolate(points, 2.5)

      assert point == {2.5, 6.25}
    end

    test "interpolation with 4 points returns a tuple {x, y} where x matches input" do
      ptest x: float(), p1: float(), p2: float(), p3: float(), p4: float() do
        points = [{1, p1}, {2, p2}, {3, p3}, {4, p4}]
        {result_x, _} = Algo.interpolate(points, x)
        result_x == x
      end
    end
  end
end

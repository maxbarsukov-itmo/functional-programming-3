defmodule InterpolationApp.Utils.PointGeneratorTest do
  @moduledoc """
  Testing InterpolationApp.Utils.PointGenerator
  """

  use ExUnit.Case, async: true
  use Quixir

  alias InterpolationApp.Utils.PointGenerator

  describe "generate/2" do
    test "generates points with correct step between given points" do
      points = [{1, 1}, {3, 3}]
      result = PointGenerator.generate(points, 0.5)
      expected = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5]
      assert result == expected
    end

    test "generates intermediate points within the start and end points" do
      ptest start: float(), finish: float(), step: float(min: 0.1, max: 1.0) do
        points = [{start, 0}, {finish, 0}]
        result = PointGenerator.generate(points, step)
        Enum.all?(result, fn x -> x >= start and x <= finish + step end)
      end
    end
  end
end

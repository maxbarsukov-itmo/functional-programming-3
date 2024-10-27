defmodule InterpolationApp.Algo.LinearInterpolation do
  @moduledoc """
  In mathematics, linear interpolation is a method of curve fitting using linear polynomials to construct
  new data points within the range of a discrete set of known data points.
  """

  @behaviour InterpolationApp.Algo.Interpolation

  def get_name, do: "Линейная интерполяция"

  def get_enough_points_count, do: 2

  @impl true
  def points_enough?(points), do: length(points) >= get_enough_points_count()

  @impl true
  def interpolate(points, target_point) when not is_list(target_point) do
    [{x0, y0}, {x1, y1}] = points

    a = (y1 - y0) / (x1 - x0)
    b = y0 - a * x0

    {target_point, a * target_point + b}
  end

  @impl true
  def interpolate(points, xs) when is_list(xs) do
    Enum.map(xs, fn x -> interpolate(points, x) end)
  end
end

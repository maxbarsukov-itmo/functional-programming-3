defmodule InterpolationApp.Algo.LinearInterpolation do
  @moduledoc """
  In mathematics, linear interpolation is a method of curve fitting using linear polynomials to construct
  new data points within the range of a discrete set of known data points.
  """

  use InterpolationApp.Algo.Interpolation

  @impl true
  def get_name, do: "Линейная интерполяция"

  @impl true
  def get_enough_points_count, do: 2

  @impl true
  def need_concrete_number_of_points?, do: true

  @impl true
  def interpolate(points, x) when not is_list(x) do
    [{x0, y0}, {x1, y1}] = points

    a = (y1 - y0) / (x1 - x0)
    b = y0 - a * x0

    {x, a * x + b}
  end
end

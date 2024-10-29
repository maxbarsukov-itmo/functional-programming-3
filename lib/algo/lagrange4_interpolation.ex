defmodule InterpolationApp.Algo.Lagrange4Interpolation do
  @moduledoc """
  In numerical analysis, the Lagrange interpolating polynomial is the
  unique polynomial of lowest degree that interpolates a given set of data.
  """

  use InterpolationApp.Algo.Interpolation

  @impl true
  def get_name, do: "Интерполяционный многочлен Лагранжа для 4 точек"

  @impl true
  def get_enough_points_count, do: 4

  @impl true
  def need_concrete_number_of_points?, do: true

  @impl true
  def interpolate(points, x) when not is_list(x) do
    [{x0, y0}, {x1, y1}, {x2, y2}, {x3, y3}] = points

    y =
      y0 * ((x - x1) * (x - x2) * (x - x3)) / ((x0 - x1) * (x0 - x2) * (x0 - x3)) +
        y1 * ((x - x0) * (x - x2) * (x - x3)) / ((x1 - x0) * (x1 - x2) * (x1 - x3)) +
        y2 * ((x - x0) * (x - x1) * (x - x3)) / ((x2 - x0) * (x2 - x1) * (x2 - x3)) +
        y3 * ((x - x0) * (x - x1) * (x - x2)) / ((x3 - x0) * (x3 - x1) * (x3 - x2))

    {x, y}
  end
end

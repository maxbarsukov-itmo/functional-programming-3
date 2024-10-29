defmodule InterpolationApp.Algo.NewtonInterpolation do
  @moduledoc """
  In the mathematical field of numerical analysis, a Newton polynomial, named after its inventor
  Isaac Newton, is an interpolation polynomial for a given set of data points.
  """

  use InterpolationApp.Algo.Interpolation

  @impl true
  def get_name, do: "Интерполяция по Ньютону"

  @impl true
  def get_enough_points_count, do: 2

  @impl true
  def need_concrete_number_of_points?, do: false

  @impl true
  def interpolate(points, x) when not is_list(x) do
    {x, points |> divided_differences |> evaluate_polynomial(points, x)}
  end

  defp divided_differences(points) do
    n = length(points)
    xs = Enum.map(points, fn {x, _} -> x end)
    ys = Enum.map(points, fn {_, y} -> y end)

    Enum.reduce(1..(n - 1), [ys], fn i, acc ->
      prev_diffs = hd(acc)

      diffs =
        Enum.map(0..(n - i - 1), fn j ->
          (Enum.at(prev_diffs, j + 1) - Enum.at(prev_diffs, j)) /
            (Enum.at(xs, j + i) - Enum.at(xs, j))
        end)

      [diffs | acc]
    end)
    |> Enum.reverse()
    |> Enum.map(&List.first/1)
  end

  defp evaluate_polynomial(coeffs, points, x) do
    xs = Enum.map(points, fn {x, _} -> x end)

    Enum.reduce(Enum.with_index(coeffs), 0, fn {coeff, i}, acc ->
      term =
        Enum.reduce(0..(i - 1), 1, fn j, prod ->
          prod * (x - Enum.at(xs, j))
        end)

      acc + coeff * term
    end)
  end
end

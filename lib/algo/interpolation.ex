defmodule InterpolationApp.Algo.Interpolation do
  @moduledoc """
  GenServer that prints new results when received
  """

  @doc """
  Interpolates a value from given points.
  """
  @callback interpolate(points :: [tuple()], target_point :: number()) :: number()

  @doc """
  Interpolates values ​​from given points.
  """
  @callback interpolate(points :: [tuple()], target_points :: [number()]) :: [number()]

  @callback get_name() :: binary()

  @callback get_enough_points_count() :: number()

  @callback need_concrete_number_of_points?() :: boolean()

  @callback points_enough?(points :: [tuple()]) :: boolean()

  defmacro __using__(_) do
    quote do
      @behaviour InterpolationApp.Algo.Interpolation

      @impl true
      def points_enough?(points), do: length(points) >= get_enough_points_count()

      @impl true
      def interpolate(points, xs) when is_list(xs) do
        Enum.map(xs, fn x -> interpolate(points, x) end)
      end
    end
  end
end

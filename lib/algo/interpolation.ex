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

  @callback points_enough?(points :: [tuple()]) :: boolean
end

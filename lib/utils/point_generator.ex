defmodule InterpolationApp.Utils.PointGenerator do
  @moduledoc """
  Генерирует промежуточные точки на основе имеющихся
  """

  @spec generate(points :: [any()], step :: number()) :: [number()]
  def generate(points, step) when is_list(points) and length(points) >= 2 do
    do_generate(
      elem(List.first(points), 0),
      elem(List.last(points), 0),
      step,
      []
    )
  end

  @spec do_generate(
          current_point :: number(),
          finish_point :: number(),
          step :: number(),
          result :: [number()]
        ) :: [number()]
  defp do_generate(current_point, finish_point, step, result)
       when current_point <= finish_point do
    do_generate(current_point + step, finish_point, step, [current_point | result])
  end

  defp do_generate(current_point, _, _, result) do
    Enum.reverse([current_point | result])
  end
end

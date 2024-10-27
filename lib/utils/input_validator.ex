defmodule InterpolationApp.Utils.InputValidator do
  @moduledoc """
  Validates input string and extracts coordinates
  """

  @spec validate_input(input :: String.t()) :: {atom(), any()}
  def validate_input(input, separator \\ ";") do
    input =
      input
      |> String.replace(~r"s{2,}", separator)
      |> String.replace(" ", separator)
      |> String.replace("\t", separator)
      |> String.replace(",", separator)
      |> String.split(separator)

    if length(input) != 2 do
      {:error, "У точки должны быть координаты"}
    else
      x = Float.parse(Enum.at(input, 0))
      y = Float.parse(Enum.at(input, 1))

      if x == :error or y == :error do
        {:error, "Координаты должны быть числами"}
      else
        {:ok, {elem(x, 0), elem(y, 0)}}
      end
    end
  end
end

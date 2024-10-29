defmodule InterpolationApp.Utils.InputValidatorTest do
  @moduledoc """
  Testing InterpolationApp.Utils.InputValidator
  """

  use ExUnit.Case, async: true
  use Quixir

  alias InterpolationApp.Utils.InputValidator

  describe "validate_input/1" do
    test "validates correct input format" do
      assert InputValidator.validate_input("1.0;2.0") == {:ok, {1.0, 2.0}}
    end

    test "returns error for non-numeric input" do
      assert InputValidator.validate_input("a;b") == {:error, "Координаты должны быть числами"}
    end

    test "returns error for incorrect format" do
      assert InputValidator.validate_input("1.0") == {:error, "У точки должны быть координаты"}
    end

    test "validates that input coordinates are numeric" do
      ptest x: float(), y: float() do
        input = "#{x};#{y}"
        {:ok, {parsed_x, parsed_y}} = InputValidator.validate_input(input)
        parsed_x == x and parsed_y == y
      end
    end
  end
end

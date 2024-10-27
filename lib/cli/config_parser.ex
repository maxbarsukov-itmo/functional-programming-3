defmodule InterpolationApp.CLI.ConfigParser do
  @moduledoc """
  Parses args for interpolation-app CLI
  """

  @methods ["linear", "lagrange2", "lagrange3", "newton"]

  def parse_args(args) do
    args
    |> Enum.reduce(%{}, &parse_arg/2)
    |> validate_args()
  end

  defp parse_arg("--method1=" <> method, acc) do
    Map.put(acc, :method1, String.trim(method))
  end

  defp parse_arg("--method2=" <> method, acc) do
    Map.put(acc, :method2, String.trim(method))
  end

  defp parse_arg("--step=" <> step, acc) do
    Map.put(acc, :step, String.trim(step))
  end

  defp parse_arg("--accuracy=" <> accuracy, acc) do
    Map.put(acc, :accuracy, String.trim(accuracy))
  end

  defp parse_arg(_, acc), do: acc

  defp validate_args(%{method1: method1, method2: method2, step: step, accuracy: accuracy}) do
    cond do
      !valid_method?(method1) ->
        {:error,
         "Неправильный method1: #{method1}. Должен быть один из [#{Enum.join(@methods, ", ")}]."}

      !valid_method?(method2) ->
        {:error,
         "Неправильный method2: #{method2}. Должен быть один из [#{Enum.join(@methods, ", ")}]."}

      !valid_step?(step) ->
        {:error,
         "Неправильный step: #{step}. Должен быть положительным числом (например: 0.1, 1, 10, ...)."}

      !valid_accuracy?(accuracy) ->
        {:error, "Неправильный accuracy: #{accuracy}. Должен быть положительным целым числом."}

      true ->
        {:ok,
         %{
           method1: module_from_method(method1),
           method2: module_from_method(method2),
           step: elem(Float.parse(step), 0),
           accuracy: elem(Integer.parse(accuracy), 0)
         }}
    end
  end

  defp validate_args(%{method1: method1, method2: method2, step: step}) do
    validate_args(%{method1: method1, method2: method2, step: step, accuracy: "3"})
  end

  defp validate_args(_) do
    {:error, "Ошибка! Обязательные аргументы: --method1=, --method2=, --step="}
  end

  defp valid_method?(method), do: method in @methods

  defp valid_step?(step) do
    case Float.parse(step) do
      {value, ""} -> value > 0
      _ -> false
    end
  end

  defp valid_accuracy?(accuracy) do
    case Integer.parse(accuracy) do
      {value, ""} -> value > 0
      _ -> false
    end
  end

  defp module_from_method(method) do
    Module.concat(["InterpolationApp", "Algo", "#{String.capitalize(method)}Interpolation"])
  end
end

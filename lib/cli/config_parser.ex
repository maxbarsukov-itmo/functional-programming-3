defmodule InterpolationApp.CLI.ConfigParser do
  @moduledoc """
  Parses args for interpolation-app CLI
  """

  @methods ["linear", "lagrange3", "lagrange4", "newton"]

  def parse_args(args) do
    args
    |> Enum.reduce(%{}, &parse_arg/2)
    |> validate_args()
  end

  defp parse_arg("methods=" <> method, acc) do
    Map.put(acc, :methods, String.split(String.trim(method), ","))
  end

  defp parse_arg("step=" <> step, acc) do
    Map.put(acc, :step, String.trim(step))
  end

  defp parse_arg("accuracy=" <> accuracy, acc) do
    Map.put(acc, :accuracy, String.trim(accuracy))
  end

  defp parse_arg(_, acc), do: acc

  defp validate_args(%{methods: methods, step: step, accuracy: accuracy}) do
    cond do
      !valid_methods?(methods) ->
        {:error,
         "Неправильный ввод методов: Методы должны быть перечислены через запятую и не повторяться.\nМетод должен быть один из [#{Enum.join(@methods, ", ")}]."}

      !valid_step?(step) ->
        {:error,
         "Неправильный step: #{step}. Должен быть положительным числом (например: 0.1, 1, 10, ...)."}

      !valid_accuracy?(accuracy) ->
        {:error, "Неправильный accuracy: #{accuracy}. Должен быть положительным целым числом."}

      true ->
        {:ok,
         %{
           methods: Enum.map(methods, &module_from_method/1),
           step: elem(Float.parse(step), 0),
           accuracy: elem(Integer.parse(accuracy), 0)
         }}
    end
  end

  defp validate_args(%{methods: methods, step: step}) do
    validate_args(%{methods: methods, step: step, accuracy: "3"})
  end

  defp validate_args(_) do
    {:error, "Ошибка! Обязательные аргументы: --methods=, --step="}
  end

  defp valid_methods?(methods) do
    Enum.uniq(methods) == methods and Enum.all?(methods, fn method -> method in @methods end)
  end

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

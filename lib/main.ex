defmodule InterpolationApp.Main do
  @moduledoc """
  Application entry point
  """

  alias InterpolationApp.CLI.{ConfigParser, Repl}

  @spec main([String.t()]) :: any()
  def main(args \\ []) do
    if Enum.member?(["--help", "-h"], List.first(args)) do
      IO.puts(help())
      System.halt()
    end

    case ConfigParser.parse_args(extract_args(args)) do
      {:ok, config} ->
        Repl.start(config)

      {:error, message} ->
        IO.puts(
          "Неверный формат запуска!\n\n#{message}\nЧтобы получить помощь, запустите программу с флагом '--help'"
        )
    end
  end

  defp extract_args(args) do
    args
      |> Enum.map(fn arg -> String.split(arg, "--") end)
      |> List.flatten()
      |> Enum.filter(fn s -> s != "" end)
  end

  defp help do
    """
    usage: interpolation-app [options] --methods=<method1,method2,...> --step=<step>
    options:
      -h, --help              Prints this message
      --accuracy=<accuracy>   Set printing accuracy

    methods:
      * linear
      * lagrange3
      * lagrange4
      * newton
    """
  end
end

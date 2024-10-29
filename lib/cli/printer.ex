defmodule InterpolationApp.CLI.Printer do
  @moduledoc """
  GenServer that prints new results when received
  """

  use GenServer

  # Client API

  def start_link(config) do
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  def print(method, result) do
    GenServer.cast(__MODULE__, {:print, method, result})
  end

  # Server Callbacks

  @impl true
  def init(config) do
    {:ok, config}
  end

  @impl true
  def handle_cast({:print, method, result}, config) do
    print_result(method, result, config.step, config.accuracy)
    {:noreply, config}
  end

  # Helper Functions

  defp print_result(method, result, step, accuracy) do
    {first_x, _} = List.first(result)

    IO.puts(
      ">> #{method.get_name()} (идем от точки из введенных #{first_x} с шагом #{step}, покрывая все введенные X)"
    )

    print_line(result, accuracy)
    IO.write("\n")
  end

  defp print_line(result, accuracy) do
    format_string = String.duplicate("~s ", length(result)) <> "~n"

    Enum.each([0, 1], fn n ->
      :io.format(
        format_string,
        Enum.map(
          result,
          &String.pad_trailing(:erlang.float_to_binary(elem(&1, n), decimals: accuracy), 7)
        )
      )
    end)
  end
end

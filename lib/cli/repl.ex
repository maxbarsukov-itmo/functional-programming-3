defmodule InterpolationApp.CLI.Repl do
  @moduledoc """
  Read-Eval-Print-Loop
  """

  alias InterpolationApp.CLI.{Applier, Interpolator, Printer}

  def start(config) do
    IO.puts("Введите 'quit', чтобы закончить ввод.")
    IO.puts("Введите узлы интерполяции:")

    {:ok, printer_pid} = Printer.start_link(config)
    {:ok, interpolator_pid} = Interpolator.start_link(config, printer_pid)
    {:ok, applier_pid} = Applier.start_link(interpolator_pid)

    # spawn(fn -> loop(applier_pid) end)
    loop(applier_pid)
  end

  defp loop(applier_pid) do
    :io.setopts(:standard_io, active: true)
    input = IO.gets("") |> check_quit

    GenServer.cast(applier_pid, {:apply_input, String.trim(input)})
    loop(applier_pid)
  end

  defp check_quit(input) do
    if input == :eof do
      :timer.sleep(100)
      quit()
    end

    if String.trim(input) == "quit" do
      quit()
    end

    input
  end

  @spec quit() :: no_return()
  defp quit do
    IO.puts("\nСпасибо за использование программы!\n")

    IO.puts("""
          |\      _,,,---,,_
    ZZZzz /,`.-'`'    -.  ;-;;,_
        |,4-  ) )-,_. ,\ (  `'-'
        '---''(_/--'  `-'\_)
    """)

    System.halt()
  end
end

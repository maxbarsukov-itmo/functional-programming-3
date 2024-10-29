defmodule InterpolationApp.CLI.PrinterTest do
  @moduledoc """
  Testing InterpolationApp.CLI.Printer
  """

  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  alias InterpolationApp.CLI.Printer

  describe "print/2" do
    test "prints method and result in expected format" do
      {:ok, pid} = Printer.start_link(%{step: 0.1, accuracy: 2})

      assert capture_io([pid: pid], fn ->
               GenServer.cast(
                 pid,
                 {:print, InterpolationApp.Algo.LinearInterpolation, [{0.0, 0.0}]}
               )

               :sys.get_state(pid)
             end) =~ ""
    end
  end
end

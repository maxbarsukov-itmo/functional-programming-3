defmodule InterpolationApp.CLI.Applier do
  @moduledoc """
  GenServer that applies input on interpolator
  """

  use GenServer

  alias InterpolationApp.Utils.InputValidator

  # Client API

  def start_link(interpolator_pid) do
    GenServer.start_link(__MODULE__, interpolator_pid, name: __MODULE__)
  end

  def apply_input(input) do
    GenServer.cast(__MODULE__, {:apply_input, input})
  end

  # Server Callbacks

  @impl true
  def init(interpolator_pid) do
    {:ok, {interpolator_pid, nil}}
  end

  @impl true
  def handle_cast({:apply_input, input}, {interpolator_pid, prev_x}) do
    {validation_status, validation_result} = InputValidator.validate_input(input)

    if validation_status == :error do
      IO.puts(validation_result)
      {:noreply, {interpolator_pid, prev_x}}
    else
      process_new_point(validation_result, prev_x, interpolator_pid)
    end
  end

  # Helper Functions

  defp process_new_point({x, y}, prev_x, interpolator_pid) do
    if prev_x == nil or prev_x < x do
      GenServer.cast(interpolator_pid, {:add_point, {x, y}})
      {:noreply, {interpolator_pid, x}}
    else
      IO.puts("Следующее значение X должно быть больше предыдущего (но #{x} < #{prev_x})")
      {:noreply, {interpolator_pid, prev_x}}
    end
  end
end

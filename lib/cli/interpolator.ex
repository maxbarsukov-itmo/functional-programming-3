defmodule InterpolationApp.CLI.Interpolator do
  @moduledoc """
  GenServer that interpolates values
  """

  use GenServer

  alias InterpolationApp.Utils.PointGenerator

  # Client API

  def start_link(config, printer_pid) do
    GenServer.start_link(__MODULE__, {config, printer_pid}, name: __MODULE__)
  end

  def add_point(point) do
    GenServer.cast(__MODULE__, {:add_point, point})
  end

  # Server Callbacks

  @impl true
  def init({config, printer_pid}) do
    {:ok, {[], config, printer_pid}}
  end

  @impl true
  def handle_cast({:add_point, point}, {points, config, printer_pid}) do
    points = Enum.reverse([point | Enum.reverse(points)])
    methods = Enum.uniq([config.method1, config.method2])

    Enum.each(methods, fn method ->
      if method.points_enough?(points) do
        limit = method.get_enough_points_count()
        interpolation_points = Enum.slice(points, -limit, limit)
        generated_points = PointGenerator.generate(interpolation_points, config.step)

        GenServer.cast(printer_pid, {
          :print,
          method,
          method.interpolate(interpolation_points, generated_points)
        })
      end
    end)

    {:noreply, {points, config, printer_pid}}
  end
end

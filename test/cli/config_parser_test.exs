defmodule InterpolationApp.CLI.ConfigParserTest do
  @moduledoc """
  Testing InterpolationApp.CLI.ConfigParser
  """

  use ExUnit.Case, async: true
  use Quixir

  alias InterpolationApp.CLI.ConfigParser

  describe "parse_args/1" do
    test "parses correct args" do
      args = ["methods=linear,lagrange3", "step=0.5", "accuracy=3"]

      assert ConfigParser.parse_args(args) ==
               {:ok,
                %{
                  methods: [
                    InterpolationApp.Algo.LinearInterpolation,
                    InterpolationApp.Algo.Lagrange3Interpolation
                  ],
                  step: 0.5,
                  accuracy: 3
                }}
    end

    test "returns error for no args" do
      assert match?({:error, _}, ConfigParser.parse_args([""]))
    end

    test "returns error for repetitive methods" do
      args = ["methods=linear,linear,linear", "step=0.5", "accuracy=3"]
      assert match?({:error, _}, ConfigParser.parse_args(args))
    end

    test "returns error for invalid methods" do
      args = ["methods=invalid,method", "step=0.5", "accuracy=3"]
      assert match?({:error, _}, ConfigParser.parse_args(args))
    end

    test "returns error for invalid step" do
      args = ["methods=invalid,method", "step=-0.5", "accuracy=3"]
      assert match?({:error, _}, ConfigParser.parse_args(args))
    end

    test "returns error for invalid accuracy" do
      args = ["methods=invalid,method", "step=-0.5", "accuracy=3.2"]
      assert match?({:error, _}, ConfigParser.parse_args(args))
    end

    test "accepts positive float step and integer accuracy" do
      ptest step: float(min: 0.1), accuracy: int(min: 1) do
        args = ["methods=linear", "step=#{step}", "accuracy=#{accuracy}"]
        {:ok, config} = ConfigParser.parse_args(args)
        config.step == step and config.accuracy == accuracy
      end
    end
  end
end

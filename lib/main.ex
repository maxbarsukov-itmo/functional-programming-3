defmodule InterpolationApp.Main do
  @moduledoc """
  Application entry point
  """

  @spec main([String.t()]) :: any()
  def main(args \\ []) do
    args
    |> parse_args()
    |> IO.puts()
  end

  defp parse_args(args) do
    {opts, word, _} = args |> OptionParser.parse(switches: [upcase: :boolean])

    {opts, List.to_string(word)}
  end
end

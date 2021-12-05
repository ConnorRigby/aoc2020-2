defmodule Day4 do
  defmodule Board do
    defstruct [:contents]
  end

  defmodule Item do
    defstruct [:value, :owner]
  end

  def from_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> parse_game()
  end

  def parse_game([draws, "" | boards]) do
    {parse_draws(draws), parse_boards(boards, [])}
  end

  def parse_boards([[_, _, _, _, _] = board | rest], acc) do
    parsed =
      Enum.map(board, fn line ->
        Regex.run(~r/^\s*(\d+)\s*(\d+)\s*(\d+)\s*(\d+)\s*(\d+)+/, line)
      end)

    parse_boards(rest, [parsed | acc])
  end

  def parse_boards([], acc), do: Enum.reverse(acc)

  def parse_draws(draws) do
    draws
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end

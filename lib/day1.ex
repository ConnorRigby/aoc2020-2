defmodule Day1 do
  def solve(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> solve_normalized()
  end

  def window_thirds(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> chunk([])
    |> Enum.map(fn
      [one, two, three] -> one+two+three
      extra -> extra
    end)
  end

  def chunk([one, two, three | rest], acc) do
    chunk([two, three | rest], [[one, two, three] | acc])
  end

  def chunk(_extra, acc), do: Enum.reverse(acc)

  def solve_normalized(input, last \\ nil, acc \\ [])
  def solve_normalized([depth | rest], last, acc) do
    solve_normalized(rest, depth, [measurement(depth, last) | acc])
  end

  def solve_normalized([], _, acc), do: Enum.reverse(acc)

  def measurement(depth, nil), do: {depth, :no_change, 0}
  def measurement(depth, last) when depth > last, do: {depth, :increased, depth - last}
  def measurement(depth, last) when depth < last, do: {depth, :decreased, abs(depth - last)}
  def measurement(depth, last) when depth == last, do: {depth, :no_change, 0}
end

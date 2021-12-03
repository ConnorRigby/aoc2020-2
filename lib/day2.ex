defmodule Day2 do
  def solve(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [command, arg] = String.split(line, " ")
      {String.to_atom(command), String.to_integer(arg)}
    end)
    |> evaluate(0, 0)
  end

  def solve2(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [command, arg] = String.split(line, " ")
      {String.to_atom(command), String.to_integer(arg)}
    end)
    |> evaluate2(0, 0, 0)
  end

  def evaluate2([{:up, amount} | rest], h, d, a) do
    evaluate2(rest, h, d, a - amount)
  end

  def evaluate2([{:down, amount} | rest], h, d, a) do
    evaluate2(rest, h, d, a + amount)
  end

  def evaluate2([{:forward, amount} | rest], h, d, a) do
    evaluate2(rest, h + amount, d + a * amount, a)
  end

  def evaluate2([], h, d, _a), do: {h, d}

  # part 1

  def evaluate([{:forward, amount} | rest], h, d) do
    evaluate(rest, h + amount, d)
  end

  def evaluate([{:up, amount} | rest], h, d) do
    evaluate(rest, h, d - amount)
  end

  def evaluate([{:down, amount} | rest], h, d) do
    evaluate(rest, h, d + amount)
  end

  def evaluate([], h, d), do: {h, d}
end

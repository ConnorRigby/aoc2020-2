defmodule Day3 do
  def solve(input) do
    normalized =
      input
      |> String.trim()
      |> String.split("\n")
      |> normalize([], [])

    [first | _] = normalized

    Enum.reduce(0..(Enum.count(first) - 1), [], fn position, acc ->
      [count(normalized, position, {0, 0}) | acc]
    end)
    |> Enum.reverse()
    |> evaluate(<<>>, <<>>)
  end

  def solve2(input) do
    normalized =
      input
      |> String.trim()
      |> String.split("\n")
      |> normalize([], [])

    [first | _] = normalized
    width = Enum.count(first) - 1

    [[o2]] =
      Enum.reduce(0..width, normalized, fn
        _, {:break, a} ->
          {:break, a}

        position, acc ->
          {zeros, ones} = count(acc, position, {0, 0})
          check = if ones >= zeros, do: 1, else: 0
          # {acc, check, position, ones, zeros}|> IO.inspect(width: 500)
          a =
            Enum.filter(acc, fn item ->
              Enum.at(item, position) == check
            end)

          if Enum.count(a) == 1, do: {:break, a}, else: a
      end)
      |> case do
        {:break, a} -> [a]
        a -> a
      end

    [[co2]] =
      Enum.reduce(0..width, normalized, fn
        _, {:break, a} ->
          {:break, a}

        position, acc ->
          {zeros, ones} = count(acc, position, {0, 0})

          check =
            case {zeros, ones} do
              {zeros, ones} when zeros < ones -> 0
              {zeros, ones} when ones < zeros -> 1
              {zeros, ones} when zeros == ones -> 0
              _ -> 1
            end

          a =
            Enum.filter(acc, fn item ->
              Enum.at(item, position) == check
            end)

          if Enum.count(a) == 1, do: {:break, a}, else: a
      end)
      |> case do
        {:break, a} -> [a]
        a -> a
      end

    {Enum.reduce(o2, <<>>, fn v, a -> a <> "#{v}" end) |> String.to_integer(2), Enum.reduce(co2, <<>>, fn v, a -> a <> "#{v}" end) |> String.to_integer(2)}
  end

  ## part1

  def evaluate([{zero, one} | rest], g, e) when zero > one do
    evaluate(rest, g <> "0", e <> "1")
  end

  def evaluate([{zero, one} | rest], g, e) when zero < one do
    evaluate(rest, g <> "1", e <> "0")
  end

  def evaluate([], g, e), do: {String.to_integer(g, 2), String.to_integer(e, 2)}

  def count([item | rest], position, {zeros, ones}) do
    case Enum.at(item, position) do
      0 -> count(rest, position, {zeros + 1, ones})
      1 -> count(rest, position, {zeros, ones + 1})
    end
  end

  def count([], _, {zeros, ones}), do: {zeros, ones}

  def normalize([<<"0", chars::binary>> | rest], current, acc) do
    normalize([chars | rest], [0 | current], acc)
  end

  def normalize([<<"1", chars::binary>> | rest], current, acc) do
    normalize([chars | rest], [1 | current], acc)
  end

  def normalize([<<>> | rest], current, acc) do
    normalize(rest, [], [Enum.reverse(current) | acc])
  end

  def normalize([], [], acc) do
    Enum.reverse(acc)
  end
end

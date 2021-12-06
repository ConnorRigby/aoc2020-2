defmodule Day5 do

  defmodule Line do
    defstruct [:points]

    defimpl Inspect do
      def inspect(%{points: [first, second]}, _opts) do
        "#{first.x},#{first.y} -> #{second.x},#{second.y}"
      end
    end
  end

  defmodule Point do
    defstruct [:x, :y]
    defimpl Inspect do
      def inspect(point, _opts) do
        "(#{point.x},#{point.y}"
      end
    end
  end

  def solve(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> plot()
  end

  def plot([line | rest], acc) do
    Enum.map(line.points, fn -> end)
  end

  def parse_line(line) do
    [[_match, x1,y1,x2,y2]] = Regex.scan(~r/^(\d+),(\d+)\s+->\s+(\d+),(\d+)/, line)
    %Line{points: [
      %Point{x: String.to_integer(x1), y: String.to_integer(x1)},
      %Point{x: String.to_integer(x2), y: String.to_integer(x2)},
    ]}
  end
end

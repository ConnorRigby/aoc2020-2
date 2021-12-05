defmodule Day4 do
  defmodule Game do
    defstruct [:draws, :boards, :found]
  end

  defmodule Board do
    defstruct [:contents, bingo: false, win: nil, won_at: -1]
  end

  defmodule Item do
    defstruct [:value, state: :unmarked]
  end

  def from_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> parse_game()
  end

  def evaulate(game) do
    game
    |> evaluate_draws(:first)
  end

  def evaulate_last(game) do
    evaluated = evaluate_draws(game, :last)

    boards =
      Enum.sort(evaluated.boards, fn %{won_at: won_at_a}, %{won_at: won_at_b} ->
        # IO.inspect({won_at_a, won_at_b})
        won_at_a >= won_at_b
      end)

    # IO.inspect(boards)
    %{evaluated | boards: boards}
    evaluate_draws(%{evaluated | boards: boards}, :last)
  end

  def evaluate_draws(%{draws: [draw | rest], boards: boards} = game, which) do
    boards =
      Enum.map(boards, fn board ->
        evaluate_board(board, draw)
      end)

    found =
      Enum.filter(boards, fn %{bingo: bingo} ->
        bingo
      end)

    found_count = Enum.count(found)
    board_count = Enum.count(boards)

    case which do
      :first when found_count == 1 ->
        %{game | found: found, draws: rest, boards: boards}

      :last when found_count == board_count ->
        %{game | found: found, draws: rest, boards: boards}

      _ ->
        evaluate_draws(%{game | found: found, draws: rest, boards: boards}, which)
    end
  end

  def evaluate_draws(%{draws: []} = game, _which) do
    game
  end

  def evaluate_board(%{bingo: true} = board, _) do
    # IO.inspect(board, label: "already bingo")
    board
  end

  def evaluate_board(%{} = board, draw) do
    contents =
      Enum.map(board.contents, fn row ->
        evaluate_row(row, draw)
      end)

    %{board | contents: contents}
    |> scan_wins(draw)
  end

  def scan_wins(%{bingo: true} = board, _draw) do
    board
  end

  def scan_wins(%{contents: contents} = board, draw) do
    found1 =
      Enum.find_value(contents, fn
        [%Item{state: :marked}, %Item{state: :marked}, %Item{state: :marked}, %Item{state: :marked}, %Item{state: :marked}] = found -> found
        [_, _, _, _, _] -> false
      end)

    [
      [a1, b1, c1, d1, e1],
      [a2, b2, c2, d2, e2],
      [a3, b3, c3, d3, e3],
      [a4, b4, c4, d4, e4],
      [a5, b5, c5, d5, e5]
    ] = contents

    found2 =
      Enum.find_value(
        [
          [a1, a2, a3, a4, a5],
          [b1, b2, b3, b4, b5],
          [c1, c2, c3, c4, c5],
          [d1, d2, d3, d4, d5],
          [e1, e2, e3, e4, e5]
        ],
        fn
          [%Item{state: :marked}, %Item{state: :marked}, %Item{state: :marked}, %Item{state: :marked}, %Item{state: :marked}] = found -> found
          [_, _, _, _, _] -> false
        end
      )

    if found1 || found2 do
      # IO.inspect(found1 || found2, label: "BINGO")
    end

    %{board | bingo: is_list(found1) || is_list(found2), win: draw, won_at: :os.system_time(:microsecond)}
  end

  def evaluate_row(row, draw) do
    Enum.map(row, fn
      %{value: ^draw} = item ->
        %{item | state: :marked}

      %{} = item ->
        item
    end)
  end

  def parse_game([draws, "" | boards]) do
    %Game{draws: parse_draws(draws), boards: parse_boards(boards, [], [])}
  end

  def parse_boards(["" | rest], buffer, acc) do
    parsed = parse_board(buffer)
    parse_boards(rest, [], [parsed | acc])
  end

  def parse_boards([board | rest], buffer, acc) do
    parse_boards(rest, [board | buffer], acc)
  end

  def parse_boards([], buffer, acc) do
    parsed = parse_board(buffer)
    Enum.reverse([parsed | acc])
  end

  def parse_board(buffer) do
    items =
      Enum.map(buffer, fn line ->
        [[_ | data]] = Regex.scan(~r/^\s*(\d+)\s*(\d+)\s*(\d+)\s*(\d+)\s*(\d+)+/, line)

        Enum.map(data, fn c ->
          %Item{value: String.to_integer(c)}
        end)
      end)
      |> Enum.reverse()

    %Board{contents: items}
  end

  def parse_draws(draws) do
    draws
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end

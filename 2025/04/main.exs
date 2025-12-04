defmodule Solution do
  @input File.read!("./input")
  @sample File.read!("./sample")

  @roll "@"
  @used "x"

  def surrounding(grid, {x, y}) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
    |> Enum.map(fn {x, y} -> grid |> Map.get(x, %{}) |> Map.get(y, nil) end)
    |> Enum.filter(&(&1 != nil))
  end

  def remove_roll(grid, {x, y}) do
    grid
    |> Map.put(x, Map.put(grid |> Map.get(x, %{}), y, @used))
  end

  def get_rolls_to_remove(grid) do
    grid
    |> Enum.flat_map(fn {x, line} ->
      line
      |> Enum.filter(fn {y, char} ->
        char == @roll and surrounding(grid, {x, y}) |> Enum.count(&(&1 == @roll)) < 4
      end)
      |> Enum.map(fn {y, _} -> {x, y} end)
    end)
  end

  def remove_rolls(grid) do
    to_remove = grid |> get_rolls_to_remove()

    updated_grid =
      to_remove |> Enum.reduce(grid, fn {x, y}, grid -> grid |> remove_roll({x, y}) end)

    {
      updated_grid,
      to_remove |> length()
    }
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, index} -> {index, char} end)
      |> Map.new()
    end)
    |> Enum.with_index()
    |> Enum.map(fn {line, index} -> {index, line} end)
    |> Map.new()
  end

  def inspect_grid(grid) do
    IO.puts(
      :stdio,
      grid
      |> Enum.map(fn {_, line} ->
        line
        |> Enum.map(fn {_, char} -> char end)
        |> Enum.join("")
      end)
      |> Enum.join("\n")
    )

    grid
  end

  def part1(input) do
    input
    |> parse_input()
    |> get_rolls_to_remove()
    |> length()
  end

  def part2(input) do
    grid =
      input
      |> parse_input()

    {_, removed} =
      Stream.from_index()
      |> Enum.reduce_while(
        {
          grid,
          0
        },
        fn _, {grid, removed} ->
          {grid, new_removed} = grid |> remove_rolls()

          op =
            if new_removed == 0 do
              :halt
            else
              :cont
            end

          {
            op,
            {
              grid,
              removed + new_removed
            }
          }
        end
      )

    removed
  end

  def get_input() do
    @input
  end

  def get_sample() do
    @sample
  end
end

case System.argv() do
  ["1", "sample"] ->
    IO.inspect({"1", "sample", Solution.part1(Solution.get_sample())})

  ["2", "sample"] ->
    IO.inspect({"2", "sample", Solution.part2(Solution.get_sample())})

  ["1"] ->
    IO.inspect({"1", "input", Solution.part1(Solution.get_input())})

  ["2"] ->
    IO.inspect({"2", "input", Solution.part2(Solution.get_input())})

  ["sample"] ->
    IO.inspect({"1", "sample", Solution.part1(Solution.get_sample())})
    IO.inspect({"2", "sample", Solution.part2(Solution.get_sample())})

  ["input"] ->
    IO.inspect({"1", "input", Solution.part1(Solution.get_input())})
    IO.inspect({"2", "input", Solution.part2(Solution.get_input())})

  _ ->
    IO.inspect({"1", "sample", Solution.part1(Solution.get_sample())})
    IO.inspect({"2", "sample", Solution.part2(Solution.get_sample())})
    IO.inspect({"1", "input", Solution.part1(Solution.get_input())})
    IO.inspect({"2", "input", Solution.part2(Solution.get_input())})
end

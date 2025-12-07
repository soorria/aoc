defmodule Solution do
  @input File.read!("./input")
  @sample File.read!("./sample")

  def get_input() do
    @input
  end

  def get_sample() do
    @sample
  end

  def run(argv) do
    case argv do
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
        IO.inspect({"1", "input", Solution.part1(Solution.get_input())})
        IO.inspect({"2", "sample", Solution.part2(Solution.get_sample())})
        IO.inspect({"2", "input", Solution.part2(Solution.get_input())})
    end
  end

  def part1(input) do
    [start | rest] = input |> String.split("\n")

    {_, starting_position} =
      start
      |> String.codepoints()
      |> Stream.with_index()
      |> Enum.find(fn {char, _} -> char == "S" end)

    starting_positions = MapSet.new() |> MapSet.put(starting_position)

    {_, num_splits} =
      rest
      |> Enum.reduce({starting_positions, 0}, fn line, {positions, num_splits} ->
        line
        |> String.codepoints()
        |> Stream.with_index()
        |> Enum.reduce({positions, num_splits}, fn {char, index}, {positions, num_splits} ->
          if char == "^" and MapSet.member?(positions, index) do
            {
              positions |> MapSet.put(index - 1) |> MapSet.put(index + 1) |> MapSet.delete(index),
              num_splits + 1
            }
          else
            {positions, num_splits}
          end
        end)
      end)

    num_splits
  end

  def part2(input) do
    [start | rest] = input |> String.split("\n")

    {_, starting_position} =
      start
      |> String.codepoints()
      |> Stream.with_index()
      |> Enum.find(fn {char, _} -> char == "S" end)

    rest
    |> Stream.map(fn line ->
      line
      |> String.codepoints()
      |> Stream.with_index()
      |> Stream.filter(fn {char, _} -> char == "^" end)
      |> Stream.map(fn {_, index} -> index end)
      |> MapSet.new()
    end)
    |> Stream.filter(fn splitters -> MapSet.size(splitters) > 0 end)
    |> Enum.reduce(Map.new([{starting_position, 1}]), fn splitters, universes ->
      universes
      |> Stream.flat_map(fn {universe, count} ->
        if MapSet.member?(splitters, universe) do
          [
            {universe - 1, count},
            {universe + 1, count}
          ]
        else
          [
            {universe, count}
          ]
        end
      end)
      |> Enum.group_by(fn {universe, _} -> universe end, fn {_, count} -> count end)
      |> Enum.into(
        Map.new(),
        fn {universe, counts} -> {universe, counts |> Enum.sum()} end
      )
    end)
    |> Map.values()
    |> Enum.sum()
  end
end

Solution.run(System.argv())

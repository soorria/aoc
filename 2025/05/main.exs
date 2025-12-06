defmodule Solution do
  @input File.read!("./input")
  @sample File.read!("./sample")

  def part1(input) do
    [ranges, ids] = String.split(input, "\n\n")

    ranges =
      ranges
      |> String.split("\n")
      |> Enum.map(fn range -> String.split(range, "-") |> Enum.map(&String.to_integer/1) end)
      |> Enum.map(fn [first, last] -> first..last end)

    valid_ids =
      ids
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> Enum.filter(fn id -> Enum.any?(ranges, fn range -> id in range end) end)

    valid_ids |> length()
  end

  def is_in_range(value, range) do
    value >= range.first and value <= range.last
  end

  def range_size(range) do
    range.last - range.first + 1
  end

  def overlaps?(range1, range2) do
    is_in_range(range1.first, range2) or is_in_range(range1.last, range2) or
      is_in_range(range2.first, range1) or is_in_range(range2.last, range1)
  end

  def merge(range1, range2) do
    %{
      first: min(range1.first, range2.first),
      last: max(range1.last, range2.last)
    }
  end

  def part2(input) do
    [ranges, _] = String.split(input, "\n\n")

    ranges
    |> String.split("\n")
    |> Stream.map(fn range -> String.split(range, "-") |> Enum.map(&String.to_integer/1) end)
    |> Stream.map(fn [first, last] -> %{first: first, last: last} end)
    |> Enum.sort_by(fn range -> range.first end, :asc)
    |> Enum.reduce([], fn range, acc ->
      case acc do
        [first | rest] ->
          if overlaps?(first, range) do
            [merge(first, range) | rest]
          else
            [range | acc]
          end

        _ ->
          [range | acc]
      end
    end)
    |> Stream.map(fn range -> range_size(range) end)
    |> Enum.sum()
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
    IO.inspect({"1", "input", Solution.part1(Solution.get_input())})
    IO.inspect({"2", "sample", Solution.part2(Solution.get_sample())})
    IO.inspect({"2", "input", Solution.part2(Solution.get_input())})
end

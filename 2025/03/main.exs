defmodule Solution do
  @input File.read!("./input")
  @sample File.read!("./sample")

  def part1_old(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line =
        line
        |> String.codepoints()
        |> Enum.map(fn char -> char |> String.to_integer() end)
        |> Enum.to_list()
        |> Enum.with_index()

      line
      |> Enum.flat_map(fn {first, first_index} ->
        line
        |> Enum.filter(fn {_, second_index} -> second_index > first_index end)
        |> Enum.map(fn {second, _} ->
          (Integer.to_string(first) <> Integer.to_string(second)) |> String.to_integer()
        end)
      end)
      |> Enum.max()
    end)
    |> Enum.sum()
  end

  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      calculate_joltage(line, 2)
    end)
    |> Enum.sum()
  end

  def to_int(num) do
    num |> Enum.join("") |> String.to_integer()
  end

  def calculate_joltage(line, num_to_consider) do
    numbers =
      line
      |> String.codepoints()
      |> Enum.map(&String.to_integer(&1))

    indexes = 0..((line |> String.length()) - num_to_consider - 1) |> Enum.reverse()

    start_num = numbers |> Enum.reverse() |> Enum.take(num_to_consider) |> Enum.reverse()

    indexes
    |> Enum.reduce(start_num, fn index, curr_max ->
      n = numbers |> Enum.at(index)

      num_to_subset = [n | curr_max]

      new_nums =
        0..num_to_consider
        |> Enum.map(fn index ->
          first_part = num_to_subset |> Enum.take(index)
          last_part = num_to_subset |> Enum.drop(index + 1)

          first_part ++ last_part
        end)

      [curr_max | new_nums]
      |> Enum.max_by(&to_int(&1))
    end)
    |> to_int()
  end

  def part2(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      calculate_joltage(line, 12)
    end)
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
    IO.inspect({"2", "sample", Solution.part2(Solution.get_sample())})
    IO.inspect({"1", "input", Solution.part1(Solution.get_input())})
    IO.inspect({"2", "input", Solution.part2(Solution.get_input())})
end

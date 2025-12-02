defmodule Solution do
  @input File.read!("./input")
  @sample File.read!("./sample")

  def parse_range(input) do
    [first, second] =
      String.split(input, "-", parts: 2)
      |> Enum.map(&String.to_integer(&1))
      |> Enum.to_list()

    {first, second}
  end

  def equal([]) do
    true
  end

  def equal([first | rest]) do
    Enum.all?(rest, fn item -> item == first end)
  end

  def is_repeated_1(number) do
    if number |> Integer.to_string() |> String.length() |> rem(2) == 1 do
      false
    else
      as_string = number |> Integer.to_string()
      half_length = String.length(as_string) |> div(2)

      first_half = as_string |> String.slice(0, half_length)

      second_half =
        as_string
        |> String.slice(half_length, half_length)

      first_half == second_half
    end
  end

  def is_repeated_2(number) do
    as_string = number |> Integer.to_string()
    length = String.length(as_string)

    # Single digit can't be "repeated at least twice"
    if length == 1 do
      false
    else
      half_length = length |> div(2)

      1..half_length
      |> Enum.any?(fn index ->
        length |> rem(index) == 0 and
          as_string
          |> String.graphemes()
          |> Enum.chunk_every(index)
          |> equal()
      end)
    end
  end

  def tee(iter, func) do
    Enum.map(iter, fn item ->
      func.(item)
      item
    end)
  end

  def get_invalid_1(current, last) when current > last do
    []
  end

  def get_invalid_1(current, last) do
    part_for_current =
      if is_repeated(current) do
        [current]
      else
        []
      end

    part_for_current ++ get_invalid_1(current + 1, last)
  end

  def get_invalid_2(current, last) when current > last do
    []
  end

  def get_invalid_2(current, last) do
    part_for_current =
      if is_repeated(current) do
        [current]
      else
        []
      end

    part_for_current ++ get_invalid_2(current + 1, last)
  end

  def part1(input) do
    input
    |> String.split(",")
    |> Enum.map(fn range -> parse_range(range) end)
    |> Enum.flat_map(fn {first, second} -> get_invalid(first, second) end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split(",")
    |> Enum.map(fn range -> parse_range(range) end)
    |> Enum.flat_map(fn {first, second} -> get_invalid(first, second) end)
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

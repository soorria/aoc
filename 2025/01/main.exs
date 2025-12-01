defmodule Solution do
  @input File.read!("./input")
  @sample File.read!("./sample")

  def wrap(n) do
    if n < 0, do: wrap(n + 100), else: n
  end

  def rotate(current, "L", amount) do
    (current - amount) |> wrap() |> rem(100)
  end

  def rotate(current, "R", amount) do
    (current + amount) |> rem(100)
  end

  def parse_instruction("L" <> rest) do
    {num, _} = Integer.parse(rest)
    {"L", num}
  end

  def parse_instruction("R" <> rest) do
    {num, _} = Integer.parse(rest)
    {"R", num}
  end

  def divmod(a, b) do
    {div(a, b), rem(a, b)}
  end

  def incr_by(_current, 0, _direction, amount) do
    {full_turns, _} = divmod(amount, 100)
    1 + full_turns
  end

  def incr_by(0, _new, _direction, amount) do
    {full_turns, _} = divmod(amount, 100)
    full_turns
  end

  def incr_by(old, _new, "L", amount) do
    {full_turns, amount} = divmod(amount, 100)
    full_turns + if old - amount < 0, do: 1, else: 0
  end

  def incr_by(old, _new, "R", amount) do
    {full_turns, amount} = divmod(amount, 100)
    full_turns + if old + amount > 100, do: 1, else: 0
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      parse_instruction(line)
    end)
  end

  def part1(input) do
    input
    |> parse()
    |> Enum.reduce({50, 0}, fn {dir, num}, {current, count} ->
      new = rotate(current, dir, num)
      new_count = if new == 0, do: count + 1, else: count

      {new, new_count}
    end)
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.reduce({50, 0}, fn {dir, num}, {current, count} ->
      new = rotate(current, dir, num)
      new_count = count + incr_by(current, new, dir, num)
      {new, new_count}
    end)
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

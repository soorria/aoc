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

  def apply_ops(enum, ops) do
    enum
    |> Stream.zip(ops)
    |> Stream.map(fn {nums, op} ->
      case op do
        "+" -> Enum.sum(nums)
        "*" -> Enum.product(nums)
      end
    end)
  end

  def part1(input) do
    [ops | nums] = input |> String.split("\n") |> Enum.reverse()

    ops =
      ops
      |> String.split(" ", trim: true)

    nums
    |> Stream.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Stream.map(fn num ->
        String.to_integer(num)
      end)
      |> Enum.to_list()
    end)
    |> Enum.zip()
    |> Enum.map(fn nums -> Tuple.to_list(nums) end)
    |> apply_ops(ops)
    |> Enum.sum()
  end

  def part2(input) do
    [ops | nums] = input |> String.split("\n") |> Enum.reverse()

    ops =
      ops
      |> String.split(" ", trim: true)

    nums
    |> Stream.map(fn line ->
      line
      |> String.codepoints()
    end)
    |> Stream.zip()
    |> Stream.map(fn chars -> Tuple.to_list(chars) end)
    |> Stream.chunk_while(
      [],
      fn col, acc ->
        if Enum.all?(col, fn char -> char == " " end) do
          {:cont, Enum.reverse(acc), []}
        else
          {:cont, [col | acc]}
        end
      end,
      fn acc ->
        {:cont, Enum.reverse(acc), []}
      end
    )
    |> Stream.map(fn nums_as_chars ->
      nums_as_chars
      |> Stream.map(fn chars ->
        chars |> Enum.reverse() |> Enum.join() |> String.trim() |> String.to_integer()
      end)
    end)
    |> apply_ops(ops)
    |> Enum.sum()
  end
end

Solution.run(System.argv())

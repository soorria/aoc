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
    input
  end

  def part2(input) do
    input
  end
end

Solution.run(System.argv())

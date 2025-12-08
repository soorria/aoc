defmodule Solution do
  def part1(input) do
    input
  end

  def part2(input) do
    input
  end

  def get_input, do: File.read!("./input")
  def get_sample, do: File.read!("./sample")

  def run(argv) do
    tasks = Map.new([{1, &part1/1}, {2, &part2/1}])

    {input_type, input} =
      case argv do
        [_, "sample"] -> {"sample", get_sample()}
        [_, "input"] -> {"input", get_input()}
        [] -> {"input", get_input()}
      end

    parts =
      case argv do
        ["1", _] -> [1]
        ["2", _] -> [2]
        [] -> [1, 2]
      end
      |> MapSet.new()

    parts
    |> Enum.map(fn part -> IO.inspect({part, input_type, tasks[part].(input)}) end)
  end
end

Solution.run(System.argv())

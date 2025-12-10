defmodule Solution do
  def area(point1, point2) do
    (abs(point1.x - point2.x) + 1) * (abs(point1.y - point2.y) + 1)
  end

  def part1(input) do
    points =
      input
      |> String.split("\n")
      |> Stream.map(fn line -> String.split(line, ",") |> Enum.map(&String.to_integer/1) end)
      |> Stream.map(fn [x, y] -> %{x: x, y: y} end)
      |> Enum.to_list()

    pairs =
      points
      |> Stream.with_index()
      |> Stream.flat_map(fn {point, index} ->
        points
        |> Stream.drop(index + 1)
        |> Stream.map(fn other_point -> {point, other_point} end)
      end)
      |> Stream.map(fn {point1, point2} -> area(point1, point2) end)
      |> Enum.sort(:desc)
      |> List.first()
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

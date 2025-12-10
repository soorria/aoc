defmodule Solution do
  def parse_machine(line) do
    parts = line |> String.split(" ")
    [desired_state | rest] = parts

    desired_state =
      desired_state
      |> String.replace_prefix("[", "")
      |> String.replace_suffix("]", "")
      |> String.codepoints()
      |> Stream.flat_map(fn c ->
        case c do
          "." -> [false]
          "#" -> [true]
        end
      end)
      |> Stream.with_index()
      |> Stream.map(fn {value, index} -> {index, value} end)
      |> Map.new()

    [joltage_req_str | rest] = rest |> Enum.reverse()

    joltage_req =
      joltage_req_str
      |> String.replace_prefix("{", "")
      |> String.replace_suffix("}", "")
      |> String.split(",")
      |> Stream.map(fn str ->
        str |> String.to_integer()
      end)
      |> Stream.with_index()
      |> Stream.map(fn {value, index} -> {index, value} end)
      |> Map.new()

    button_wirings =
      rest
      |> Enum.reverse()
      |> Stream.map(fn str ->
        str
        |> String.replace_prefix("(", "")
        |> String.replace_suffix(")", "")
        |> String.split(",")
        |> Stream.map(fn str ->
          str |> String.to_integer()
        end)
        |> Enum.to_list()
      end)
      |> Enum.to_list()

    %{desired_state: desired_state, joltage_req: joltage_req, button_wirings: button_wirings}
  end

  def part1(input) do
    input |> String.split("\n") |> Enum.map(&parse_machine/1)
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

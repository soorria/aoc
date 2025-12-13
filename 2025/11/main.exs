defmodule Solution do
  def parse(input) do
    input
    |> String.split("\n")
    |> Stream.map(fn line ->
      [source, targets] =
        line
        |> String.split(":", trim: true)

      targets =
        targets
        |> String.split(" ", trim: true)
        |> MapSet.new()

      {source, targets}
    end)
    |> Enum.reduce(Map.new(), fn {source, targets}, acc ->
      Map.put(acc, source, targets)
    end)
  end

  def dfs(graph, path, seen, paths) do
    [node | _] = path

    if path |> length() > 572 do
      IO.puts("BRUH")
    end

    cond do
      node == "out" ->
        IO.inspect({"found path", path})
        {[path | paths], seen}

      MapSet.member?(seen, path) ->
        {paths, seen}

      true ->
        seen = MapSet.put(seen, path)
        targets = Map.get(graph, node, MapSet.new())

        Enum.reduce(targets, {paths, seen}, fn target, {paths, seen} ->
          dfs(graph, [target | path], seen, paths)
        end)
    end
  end

  def part1(input) do
    graph = parse(input)
    {paths, _} = dfs(graph, ["you"], MapSet.new(), [])
    paths |> length()
  end

  def part2(input) do
    graph = parse(input)
    {paths, _} = dfs(graph, ["svr"], MapSet.new(), [])

    paths
    |> IO.inspect()
    |> Stream.map(fn path -> path |> MapSet.new() end)
    |> Stream.filter(fn path -> MapSet.member?(path, "dac") and MapSet.member?(path, "fft") end)
    |> Enum.count()
  end

  def get_input, do: File.read!("./input")
  def get_sample, do: File.read!("./sample")
  def get_sample_2, do: File.read!("./sample-2")

  def run(argv) do
    tasks = Map.new([{1, &part1/1}, {2, &part2/1}])

    parts =
      case argv do
        ["1", _] -> [1]
        ["2", _] -> [2]
        [] -> [1, 2]
      end
      |> MapSet.new()

    {input_type, input} =
      case argv do
        [_, "sample"] -> {"sample", get_sample()}
        [_, "input"] -> {"input", get_input()}
        [] -> {"input", get_input()}
      end

    parts
    |> Enum.map(fn part ->
      input =
        if input_type == "sample" and part == 2 do
          get_sample_2()
        else
          input
        end

      IO.inspect({part, input_type, tasks[part].(input)})
    end)
  end
end

Solution.run(System.argv())

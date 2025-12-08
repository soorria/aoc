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

  # euclidean distance
  def distance(%{x: x1, y: y1, z: z1}, %{x: x2, y: y2, z: z2}) do
    :math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2) + :math.pow(z1 - z2, 2))
  end

  def get_all_connected(graph, nil) do
    {MapSet.new(), graph}
  end

  def get_all_connected(graph, point) do
    {connected, graph} = Map.pop(graph, point, MapSet.new())

    {connected, graph} =
      Enum.reduce(connected, {connected, graph}, fn point, {acc_connected, acc_graph} ->
        {new_connected, updated_acc_graph} = get_all_connected(acc_graph, point)

        {MapSet.union(acc_connected, new_connected), updated_acc_graph}
      end)

    {connected, graph}
  end

  def get_groups_single(graph, point, seen, group) do
    updated_seen = MapSet.put(seen, point)
    updated_group = [point | group]

    {updated_seen, updated_group} =
      Enum.reduce(graph[point], {updated_seen, updated_group}, fn node, {acc_seen, acc_group} ->
        if MapSet.member?(acc_seen, node) do
          {acc_seen, acc_group}
        else
          get_groups_single(graph, node, acc_seen, acc_group)
        end
      end)

    {updated_seen, updated_group}
  end

  def get_groups(graph) do
    points = Map.keys(graph)

    {_, groups} =
      points
      |> Enum.reduce({MapSet.new(), []}, fn node, {seen, groups} ->
        if MapSet.member?(seen, node) do
          {seen, groups}
        else
          {updated_seen, new_group} = get_groups_single(graph, node, seen, [])

          {updated_seen, [new_group | groups]}
        end
      end)

    groups
  end

  def prepare(input) do
    points =
      input
      |> String.split("\n")
      |> Stream.map(&String.split(&1, ","))
      |> Stream.map(fn [x, y, z] ->
        %{x: String.to_integer(x), y: String.to_integer(y), z: String.to_integer(z)}
      end)
      |> Enum.to_list()

    distances =
      points
      |> Stream.with_index()
      |> Stream.flat_map(fn {point1, index} ->
        points
        |> Stream.drop(index + 1)
        |> Stream.map(fn point2 ->
          {
            distance(point1, point2),
            point1,
            point2
          }
        end)
      end)
      |> Enum.sort()

    {distances, points}
  end

  def graph_add_edge(graph, point1, point2) do
    point1_connected = Map.get(graph, point1, MapSet.new())
    point2_connected = Map.get(graph, point2, MapSet.new())

    graph
    |> Map.put(point1, MapSet.put(point1_connected, point2))
    |> Map.put(point2, MapSet.put(point2_connected, point1))
  end

  def part1(input) do
    {distances, _} = prepare(input)

    groups =
      distances
      |> Enum.reduce(Map.new(), fn {_, point1, point2}, acc ->
        graph_add_edge(acc, point1, point2)
      end)
      |> get_groups()

    groups
    |> Stream.map(fn group -> length(group) end)
    |> Enum.sort(:desc)
    |> Stream.take(3)
    |> Enum.product()
  end

  def part2(input) do
    {distances, points} = prepare(input)

    num_points = length(points)

    {_graph, last} =
      distances
      |> Enum.reduce_while({Map.new(), nil}, fn {_, point1, point2}, {graph, _} ->
        updated_graph = graph_add_edge(graph, point1, point2)
        [first_group | rest] = get_groups(updated_graph)

        if length(first_group) == num_points and length(rest) == 0 do
          {:halt, {updated_graph, {point1, point2}}}
        else
          {:cont, {updated_graph, nil}}
        end
      end)

    {point1, point2} = last

    point1.x * point2.x
  end
end

Solution.run(System.argv())

defmodule AdventOfCode.Year2024.Day1 do
  @moduledoc """
  Advent of code for 1/12/2024
  """

  def run(path) do
    {list1, list2} =
      path
      |> File.stream!()
      |> Enum.reduce({[], []}, fn input, {list1, list2} ->
        [input1, input2] = input |> String.split() |> Enum.map(&String.to_integer/1)
        {[input1 | list1], [input2 | list2]}
      end)

    part1(list1, list2)
    part2(list1, list2)
  end

  defp part1(list1, list2) do
    [list1, list2]
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip()
    # Enum.sum_by is added in elixir 1.18
    |> Enum.map(fn {input1, input2} -> abs(input1 - input2) end)
    |> Enum.sum()
    |> IO.inspect(label: "part 1")
  end

  defp part2(list1, list2) do
    frequencies = Enum.frequencies(list2)

    list1
    |> Enum.map(fn input -> input * Map.get(frequencies, input, 0) end)
    |> Enum.sum()
    |> IO.inspect(label: "part 2")
  end
end

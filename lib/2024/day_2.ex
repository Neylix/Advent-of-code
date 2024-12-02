defmodule AdventOfCode.Year2024.Day2 do
  @moduledoc """
  Advent of code for 2/12/2024
  """

  def run(path) do
    reports =
      path
      |> File.stream!()
      |> Enum.map(fn report -> report |> String.split() |> Enum.map(&String.to_integer/1) end)

    part1(reports)
    part2(reports)
  end

  #### PART 1 ####
  defp part1(reports), do: reports |> Enum.count(&valid_report_chunk?/1) |> IO.inspect(label: "part 1")

  # Exemple with chunk_every, easier but with more loops
  defp valid_report_chunk?(report) do
    report = if List.first(report) > List.last(report), do: Enum.reverse(report), else: report

    report
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [first, second] -> first < second and second - first < 4 end)
  end

  # Exemple with reduce, more complex but more efficient
  defp valid_report_reduce?(report) do
    [first, second | rest] = report
    direction = if first > second, do: :>, else: :<

    [second | rest]
    |> Enum.reduce_while(
      {first, true},
      fn second, {first, _} ->
        diff = abs(second - first)

        if diff < 4 and apply(Kernel, direction, [first, second]),
          do: {:cont, {second, true}},
          else: {:halt, {second, false}}
      end
    )
    |> elem(1)
  end

  #### PART 2 ####
  defp part2(reports), do: reports |> Enum.count(&valid_report?/1) |> IO.inspect(label: "part 2")

  # Could find better algo but brute force works
  defp valid_report?(report) do
    if valid_report_reduce?(report) do
      true
    else
      range = 0..(length(report) - 1)
      Enum.any?(range, fn i -> report |> List.delete_at(i) |> valid_report_reduce?() end)
    end
  end
end

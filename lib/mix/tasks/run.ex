defmodule Mix.Tasks.AdventOfCode.Run do
  @moduledoc """
  Run the challenge code for a year and a day.

  ## Command line options

    * `--help` - show this help
    * `--year` specify advent of code year (default to current year)
    * `--day` specify advent of code day (default to current day)

  ## Example
  ```sh
  mix advent_of_code.run --year 2024 --day 1
  ```
  """

  require Logger

  def run(args) do
    {opts, _} =
      OptionParser.parse!(args,
        strict: [help: :boolean, year: :integer, day: :integer, cookie_session: :string]
      )

    if Keyword.get(opts, :help, false),
      do: Mix.shell().cmd("mix help #{Mix.Task.task_name(__MODULE__)}"),
      else: do_run(opts)
  end

  defp do_run(opts) do
    %DateTime{year: current_year, day: current_day} =
      :second |> System.system_time() |> DateTime.from_unix!()

    year = Keyword.get(opts, :year, current_year)
    day = Keyword.get(opts, :day, current_day)

    module = String.to_existing_atom("Elixir.AdventOfCode.Year#{year}.Day#{day}")

    directory_path = "./priv/inputs/#{year}"
    filename = "day_#{day}_input.txt"
    path = Path.join(directory_path, filename)

    apply(module, :run, [path])
  end
end

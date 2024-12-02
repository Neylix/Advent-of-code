defmodule Mix.Tasks.AdventOfCode.Init do
  @moduledoc """
  Initialize the challenge for a year and a day.
  It create directory for under lib/[YEAR]/[DAY] and downloads the input as input.txt

  ## Command line options

    * `--help` - show this help
    * `--year` specify advent of code year (default to current year)
    * `--day` specify advent of code day (default to current day)
    * `--cookie_session` specify the cookie session you can retrieve in your browser (required)

  ## Example
  ```sh
  mix advent_of_code.init --year 2024 --day 1
  ```
  """

  require Logger

  def run(args) do
    {opts, _} =
      OptionParser.parse!(args,
        strict: [help: :boolean, year: :integer, day: :integer, cookie_session: :string]
      )

    cond do
      Keyword.get(opts, :help, false) ->
        Mix.shell().cmd("mix help #{Mix.Task.task_name(__MODULE__)}")

      not Keyword.has_key?(opts, :cookie_session) ->
        Logger.error("cookie session option is required")
        Mix.shell().cmd("mix help #{Mix.Task.task_name(__MODULE__)}")

      true ->
        init(opts)
    end
  end

  defp init(opts) do
    Application.ensure_all_started(:req)

    %DateTime{year: current_year, day: current_day} =
      :second |> System.system_time() |> DateTime.from_unix!()

    year = Keyword.get(opts, :year, current_year)
    day = Keyword.get(opts, :day, current_day)
    cookie_session = Keyword.fetch!(opts, :cookie_session)

    download_inputs_file(year, day, cookie_session)
    create_code_file(year, day)
  end

  defp download_inputs_file(year, day, cookie_session) do
    directory_path = "./priv/inputs/#{year}"
    filename = "day_#{day}_input.txt"
    path = Path.join(directory_path, filename)

    if File.exists?(path) do
      Logger.info("Input file already downloaded to #{path}")
    else
      File.mkdir_p!(directory_path)

      headers = %{"cookie" => "session=#{cookie_session}"}

      Req.get!("https://adventofcode.com/#{year}/day/#{day}/input",
        headers: headers,
        into: File.stream!(path)
      )

      Logger.info("Input file downloaded to #{path}")
    end
  end

  defp create_code_file(year, day) do
    directory_path = "./lib/#{year}"
    filename = "day_#{day}.ex"
    path = Path.join(directory_path, filename)

    if File.exists?(path) do
      Logger.info("Code file already exists at #{path}")
    else
      File.mkdir_p!(directory_path)

      content = """
      defmodule AdventOfCode.Year#{year}.Day#{day} do
        @moduledoc \"""
        Advent of code for #{day}/12/#{year}
        \"""

        def run(_input) do
        end
      end
      """

      File.write!(path, content)

      Logger.info("Code file create at #{path}")
    end
  end
end

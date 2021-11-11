defmodule Data do
  @id_html_path "h4:fl-contains('Offenders') + table > tr > td > tr > td > tr > td > tr > td > tr > td > tr > td > tr > td > tr > td > tr > td > tr > td > tr > td > tr > td > tr > td > tr a"
  @offenses_html_path "div.header:fl-contains('Offenses') + div > table a[href='OffenseCode.aspx?id=1239']"

  def zipcodes() do
    File.stream!("zipcodes.csv")
    |> NimbleCSV.RFC4180.parse_stream
    |> Enum.filter(fn [_, _, _, _, _, _, state, _, _, _, _, _, _, _, _] -> state == "SC" end)
    |> Enum.map(&List.first/1)
  end

  def parse_id(href) do
    Regex.run(~r/Id=(\d+)/, href) |> List.last()
  end

  def get_ids(html) do
    Floki.parse_document!(html)
    |> Floki.find(@id_html_path)
    |> Floki.attribute("href")
    |> Enum.map(&parse_id/1)
  end

  def pull_list do
    zipcodes()
    |> Enum.take(1)
    |> Enum.map(&SCHTTPClient.fetch_list/1)
    |> Enum.flat_map(&get_ids/1)
    |> Enum.take(1)
    |> Enum.map(&SCHTTPClient.fetch_individual/1)
    |> Enum.map(&pull_individual/1)
  end

  def pull_individual(html) do
    document = Floki.parse_document!(html)
    if has_buggery_charge?(document) do
      File.write("tmp/people/#{document |> id_from_html()}.html", html)
    end
  end

  def id_from_html(document) do
    document
    |> Floki.find("body form")
    |> Floki.attribute("action")
    |> List.first()
    |> String.split("=")
    |> List.last()
  end

  def has_buggery_charge?(document) do
    document |> Floki.find(@offenses_html_path) |> Enum.any?
  end

  def fetch_offenses do
    (1000..1700)
    |> Enum.each(fn id ->
      :timer.sleep(1000)
      IO.puts("Fetching #{id}")
      SCHTTPClient.fetch_offense(id)
      |> case do
        {:ok, response} -> {id, response.body}
        {:error, failure} -> IO.puts("Something went wrong with the request #{failure}")
      end
      |> case do
        {id, body} when is_integer(id) -> unless String.match?(body, ~r/No Offense Description available/) do File.write("#{id}.html", body)end
        otherwise -> otherwise
      end
    end)
  end

end

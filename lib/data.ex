defmodule Data do
  def zipcodes() do
    File.stream!("zipcodes.csv")
    |> NimbleCSV.RFC4180.parse_stream
    |> Enum.filter(fn [_, _, _, _, _, _, state, _, _, _, _, _, _, _, _] -> state == "SC" end)
    |> Enum.map(&List.first/1)
    |> Enum.at(0)
  end
end

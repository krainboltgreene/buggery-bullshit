defmodule SCHTTPClient do
  @search_url "http://scor.sled.sc.gov/GeographicalSearch.aspx"
  @individual_url "http://scor.sled.sc.gov/OffenderDetails.aspx?Display=Main&Id="
  @search_headers [
    {"Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"},
    {"Accept-Language", "en-US,en;q=0.9"},
    {"Cache-Control", "max-age=0"},
    {"Content-Type", "application/x-www-form-urlencoded"},
    {"Upgrade-Insecure-Requests", "1"},
    {"Referrer", @search_url},
    {"Origin", "http://scor.sled.sc.gov"},
    {"Connection", "keep-alive"},
    {"DNT", "1"},
    {"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"},
    {"Cookie", "ASP.NET_SessionId=3g3433saivmkjepwv5tlhhwe"}
  ]
  @individual_headers [
    {"Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"},
    {"Accept-Language", "en-US,en;q=0.9"},
    {"Cache-Control", "max-age=0"},
    {"Upgrade-Insecure-Requests", "1"},
    {"Referrer", @search_url},
    {"Origin", "http://scor.sled.sc.gov"},
    {"Connection", "keep-alive"},
    {"DNT", "1"},
    {"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"},
    {"Cookie", "ASP.NET_SessionId=g5rvvvks1g13r0j1twhsyzkx"}
  ]

  # def get_item(item_id) do
  #   :get
  #   |> Finch.build("https://hacker-news.firebaseio.com/v0/item/#{item_id}.json")
  #   |> Finch.request(__MODULE__)
  # end

  def fetch_offense(id) do
    Finch.build(:get, "http://scor.sled.sc.gov/OffenseCode.aspx?id=#{id}", @individual_headers, nil, receive_timeout: 400_000) |> Finch.request(__MODULE__)
  end

  def fetch_individual(id) do
    Finch.build(:get, "#{@individual_url}#{id}", @individual_headers, nil, receive_timeout: 400_000) |> Finch.request(__MODULE__)
  end

  # Example 29052
  def fetch_list(zipcode) do
    Finch.build(:post, @search_url, @search_headers, zipcode |> list_parameters() |> to_form_data(), receive_timeout: 400_000) |> Finch.request(__MODULE__)
  end

  def to_form_data(mapping) do
    mapping
    |> Enum.map(fn {key, value} -> "#{key |> URI.encode_www_form}=#{value |> String.trim() |> URI.encode_www_form}" end)
    |> Enum.join("&")
  end

  def list_parameters(zipcode) do
    [
      {"__EVENTTARGET", ""},
      {"__EVENTARGUMENT", ""},
      {"__VIEWSTATE", File.read!("viewstate.txt")},
      {"__VIEWSTATEGENERATOR", "1BC21D99"},
      {"ctl00_ContentPlaceHolder1_AddressMap_ClientState", "[]"},
      {"__VIEWSTATEENCRYPTED", ""},
      {"__EVENTVALIDATION", File.read!("eventvalidation.txt")},
      {"ctl00$ContentPlaceHolder1$txtStreet", ""},
      {"ctl00$ContentPlaceHolder1$txtCity", ""},
      {"ctl00$ContentPlaceHolder1$ddlState", ""},
      {"ctl00$ContentPlaceHolder1$txtZip", zipcode},
      {"ctl00$ContentPlaceHolder1$ddlDistance", "1"},
      {"ctl00$ContentPlaceHolder1$rdoSearchType", "rdoZipcode"},
      {"ctl00$ContentPlaceHolder1$btnSearch", "Search"}
    ]
  end
end

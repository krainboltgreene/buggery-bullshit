defmodule DataTest do
  use ExUnit.Case

  # test "get_ids" do
  #   assert File.read!("response.html") |> Data.get_ids() == []
  # end

  test "pull_data(html)" do
    assert File.read!("response-individual.html") |> Data.pull_data() == true
  end
end

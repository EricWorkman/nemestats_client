defmodule NemeStats do
  @moduledoc """
  Nemestats.com API wrapper

  Use this in clients to interact with Nemestats' API.

  ## Examples

  defmodule MyClient do
    require NemeStats

    def login(username, password) do
      body = Poison.encode!(%{userName: username, password: password})
      NemeStats.post("UserSessions/", [body: body]).body
    end
  end
  """

  use HTTPotion.Base

  @expected_fields ~w(authenticationToken authenticationTokenExpirationDateTime)

  def process_url(url) do
    "https://nemestats.com/api/v2/" <> url
  end

  def process_request_headers(headers) do
    Dict.put(headers, :"Content-Type", "application/json")
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Map.take(@expected_fields)
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  end
end

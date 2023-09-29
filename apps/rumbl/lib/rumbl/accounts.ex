defmodule Rumbl.Accounts do
  @moduledoc false
  alias Rumbl.Accounts.User

  def list_users() do
    [
      %User{id: 1, name: "José", username: "josevalim"},
      %User{id: 2, name: "Sasa", username: "uric"},
      %User{id: 3, name: "chris", username: "mccord"}
    ]
  end

  def get_user(id) do
    Enum.find(list_users(), fn user -> user.id == id end)
  end

  def get_user_by(params) do
    Enum.find(list_users(), fn map ->
      params |> Enum.all?(fn {key, value} -> Map.get(map, key) == value end)
    end)
  end
end

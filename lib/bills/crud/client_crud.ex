defmodule Bills.Crud.ClientCrud do
  @moduledoc """
    Client CRUD module
  """
  alias Bills.{Schema.Client, Repo}

  def get_by_id(id) do
    Repo.get(Client, id)
  end

  def get_by_id!(id) do
    Repo.get!(Client, id)
  end

  def get_by_identification(identification_number) do
    Repo.get_by(Client, identification_number: identification_number)
  end

  def create_client(params) do
    %Client{}
    |> Client.changeset(params)
    |> Repo.insert()
  end

  def create_client_if_not_exists(params) do
    case get_by_identification(params.identification_number) do
      nil ->
        create_client(params)

      client ->
        {:ok, client}
    end
  end

  def update_client(%Client{} = client, params) do
    client
    |> Client.changeset(params)
    |> Repo.update()
  end

  def delete_client(%Client{} = client) do
    Repo.delete(client)
  end
end

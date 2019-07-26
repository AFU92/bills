defmodule Bills.Crud.ItemCrud do
  @moduledoc """
    Item CRUD module
  """
  alias Bills.{Schema.Item, Repo}

  def get_by_id(id) do
    Repo.get(Item, id)
  end

  def get_by_id!(id) do
    Repo.get!(Item, id)
  end

  def get_by_code(code) do
    Repo.get_by(Item, code: code)
  end

  def create_item(params) do
    %Item{}
    |> Item.changeset(params)
    |> Repo.insert()
  end

  def create_item_if_not_exists(params) do
    case get_by_code(params.code) do
      nil ->
        create_item(params)

      item ->
        {:ok, item}
    end
  end

  def update_item(%Item{} = item, params) do
    item
    |> Item.changeset(params)
    |> Repo.update()
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end
end

defmodule Bills.Schema.Item do
  @moduledoc """
      Item model
  """
  use Ecto.Schema
  alias Bills.Schema.BillItem

  import Ecto.Changeset

  schema "items" do
    field(:name, :string)
    field(:description, :string)
    field(:price, :float)
    field(:code, :string)

    has_many(:billItems, BillItem)

    timestamps()
  end

  @required_fields [:name, :description, :price, :code]
  @optional_fields []

  def changeset(items, params \\ %{}) do
    items
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:code, name: :item_code_uq)
  end
end

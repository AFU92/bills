defmodule Bills.Schema.Bill do
  @moduledoc """
      Bill model
  """
  use Ecto.Schema
  alias Bills.Schema.{Client, BillItem}

  import Ecto.Changeset

  schema "bills" do
    field(:total_price, :float)
    field(:bill_number, :string)

    belongs_to(:client, Client)
    has_many(:bill_items, BillItem)

    timestamps()
  end

  @required_fields [:total_price]
  @optional_fields []

  def changeset(bill, params \\ %{}) do
    bill
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end

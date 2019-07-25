defmodule Bills.Schema.Client do
  @moduledoc """
      Clients model
  """
  use Ecto.Schema
  alias Bills.Schema.Bill

  import Ecto.Changeset

  schema "clients" do
    field(:name, :string)
    field(:last_name, :string)
    field(:identification_number, :string)

    has_many(:bills, Bill)

    timestamps()
  end

  @required_fields [:name, :last_name, :identification_number]
  @optional_fields []

  def changeset(client, params \\ %{}) do
    client
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:identification_number, name: :client_identification_uq)
  end
end

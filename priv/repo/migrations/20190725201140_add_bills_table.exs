defmodule Bills.Repo.Migrations.AddBillsTable do
  use Ecto.Migration

  def change do
    create table(:bills) do
      add(:total_price, :float)

      add(:client_id, references(:clients, null: false))

      timestamps()
    end
  end
end

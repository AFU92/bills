defmodule Bills.Repo.Migrations.AddBillItemsTable do
  use Ecto.Migration

  def change do
    create table(:bill_items) do
      add(:unit_price, :float)
      add(:percent_discount, :float)
      add(:quantity, :float)
      add(:total_quantity_price, :float)

      add(:bill_id, references(:bills, null: false))
      add(:item_id, references(:items, null: false))

      timestamps()
    end
  end
end

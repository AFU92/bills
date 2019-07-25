defmodule Bills.Repo.Migrations.AddItemsTable do
  use Ecto.Migration

  def change do
    create table(:items) do
      add(:name, :string)
      add(:description, :string)
      add(:price, :float)
      add(:code, :string)

      timestamps()
    end

    create unique_index(:items, [:code], name: :item_code_uq)
  end
end

defmodule Bills.Repo.Migrations.AddColumnNumberInBillsTable do
  use Ecto.Migration

  def change do
    alter table(:bills) do
      add(:bill_number, :string)
    end
  end
end

defmodule Bills.Repo.Migrations.AddClientsTable do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add(:name, :string)
      add(:last_name, :string)
      add(:identification_number, :string)

      timestamps()
    end

    create unique_index(:clients, [:identification_number], name: :client_identification_uq)
  end
end

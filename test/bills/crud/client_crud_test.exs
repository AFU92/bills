defmodule Bills.Crud.ClientCrudTest do
  @moduledoc """
    Client CRUD Test module
  """
  use Bills.DataCase

  alias Bills.Crud.ClientCrud
  alias Bills.Schema.Client

  setup do
    client = insert(:client)

    {:ok, client: client}
  end

  describe "testing get client" do
    test "get client by id successfully", %{client: %{id: client_id}} do
      result = ClientCrud.get_by_id(client_id)

      assert %{
               name: name,
               last_name: last_name,
               identification_number: identification_number
             } = result

      assert %Client{} = result
      assert result.id == client_id
    end

    test "get client by id failed" do
      result = ClientCrud.get_by_id(0)
      assert result == nil
    end

    test "get! client by id successfully",
         %{client: %{id: client_id}} do
      result = ClientCrud.get_by_id!(client_id)
      assert %Client{id: ^client_id} = result
    end

    test "get! client by id failed" do
      assert_raise Ecto.NoResultsError, fn -> ClientCrud.get_by_id!(0) end
    end

    test "get client by identification_number successfully",
         %{client: %{identification_number: identification_number}} do
      result = ClientCrud.get_by_identification(identification_number)

      assert %{
               name: name,
               last_name: last_name,
               identification_number: identification_number
             } = result

      assert %Client{} = result
      assert result.identification_number == identification_number
    end

    test "get client by identification_number failed" do
      result = ClientCrud.get_by_identification("identification_number")
      assert result == nil
    end
  end

  describe "testing create client" do
    test "create a client successfully" do
      assert {:ok, client} =
               :client
               |> params_for()
               |> ClientCrud.create_client()
    end

    test "create a client failed" do
      assert {:error, changeset} = ClientCrud.create_client(%{})
      assert length(changeset.errors) != 0
    end

    test "create_client_if_not_exists get existing",
         %{client: client} do
      assert {:ok, client} =
               client
               |> Map.from_struct()
               |> ClientCrud.create_client_if_not_exists()
    end

    test "create_client_if_not_exists create new one" do
      assert {:ok, client} =
               :client
               |> params_for()
               |> ClientCrud.create_client_if_not_exists()
    end
  end

  describe "testing update a client" do
    test "update a client successfully", %{client: client} do
      name = "name client"
      last_name = "last_name client"
      identification_number = "55-1111"

      assert {:ok, result_client} =
               ClientCrud.update_client(client, %{
                 name: name,
                 last_name: last_name,
                 identification_number: identification_number
               })

      assert result_client.id == client.id
      assert result_client.name == name
      assert result_client.last_name == last_name
      assert result_client.identification_number == identification_number
    end

    test "update a client failed" do
      assert {:error, changeset} = ClientCrud.update_client(%Client{}, %{})
      assert length(changeset.errors) != 0
      assert changeset.valid? == false
    end
  end

  describe "testing delete a client" do
    test "delete a client successfully", %{client: client} do
      assert {:ok, _client} = ClientCrud.delete_client(client)
    end
  end
end

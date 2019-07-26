defmodule Bills.Validator.BulkValidator do
  alias Bills.Crud.{BillItemCrud, BillCrud, ItemCrud, ClientCrud}
  alias Ecto.Multi
  alias Bills.Repo

  def reading_file(path, _separator) do
    File.stream!(path)
    |> CSV.decode(
      separator: ?;,
      headers: [
        :bill_number,
        :client_name,
        :client_last_name,
        :client_identification,
        :item_name,
        :item_code,
        :item_description,
        :item_quantity,
        :item_price,
        :percent_discount
      ]
    )
    |> Enum.reduce(%{correct_data: [], error_data: []}, fn row, result ->
      case row do
        {:ok, row_data} ->
          result
          |> Map.put(:correct_data, Map.get(result, :correct_data) ++ [row_data])

        {:error, error_data} ->
          result
          |> Map.put(:error_data, Map.get(result, :error_data) ++ [error_data])
      end
    end)
  end

  def load_data(data) do
    Enum.with_index(data, 1)
    |> Enum.reduce(%{correct_data: [], error_data: []}, fn {%{
                                                              bill_number: bill_number,
                                                              client_name: client_name,
                                                              client_last_name: client_last_name,
                                                              client_identification:
                                                                client_identification,
                                                              item_name: item_name,
                                                              item_code: item_code,
                                                              item_description: item_description,
                                                              item_quantity: item_quantity,
                                                              item_price: item_price,
                                                              percent_discount: percent_discount
                                                            }, row_number},
                                                           result ->
      {item_quantity, _} = Float.parse(item_quantity)
      {percent_discount, _} = Float.parse(percent_discount)
      {item_price, _} = Float.parse(item_price)

      client_params = %{
        name: client_name,
        last_name: client_last_name,
        identification_number: client_identification
      }

      item_params = %{
        name: item_name,
        description: item_description,
        price: item_price,
        code: item_code
      }

      item_total_price = item_price * item_quantity * (100 - percent_discount)

      bill_item_params = %{
        unit_price: item_price,
        percent_discount: percent_discount,
        quantity: item_quantity,
        total_quantity_price: item_total_price
      }

      bill_params = %{
        bill_number: bill_number,
        total_price: item_total_price
      }

      line_msg = "The result of the line #{row_number} was: "

      case load_data_transaction(client_params, item_params, bill_item_params, bill_params) do
        {:ok, msg} ->
          result
          |> Map.put(:correct_data, Map.get(result, :correct_data) ++ [line_msg <> msg])

        {:error, msg} ->
          result
          |> Map.put(:error_data, Map.get(result, :error_data) ++ [line_msg <> msg])
      end
    end)
  end

  defp load_data_transaction(client_params, item_params, bill_item_params, bill_params) do
    Multi.new()
    |> create_item(item_params)
    |> create_client(client_params)
    |> create_bill(bill_params)
    |> create_bill_item(bill_item_params)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        {:ok, "Data inserted sucessfully"}

      {:error, multi_name, _, _} ->
        {:error, "Error inserting #{Atom.to_string(multi_name)}"}
    end
  end

  defp create_item(multi, item_params) do
    multi
    |> Multi.run(:create_item, fn _repo, _ ->
      item_params
      |> ItemCrud.create_item_if_not_exists()
    end)
  end

  defp create_client(multi, client_params) do
    multi
    |> Multi.run(:create_client, fn _repo, _ ->
      client_params
      |> ClientCrud.create_client_if_not_exists()
    end)
  end

  defp create_bill(multi, bill_params) do
    multi
    |> Multi.run(:create_bill, fn _repo, %{create_client: client} ->
      bill_params
      |> Map.put(:client_id, client.id)
      |> BillCrud.create_or_update_bill()
    end)
  end

  defp create_bill_item(multi, bill_item_params) do
    multi
    |> Multi.run(:create_bill_item, fn _repo, %{create_item: item, create_bill: bill} ->
      bill_item_params
      |> Map.put(:item_id, item.id)
      |> Map.put(:bill_id, bill.id)
      |> BillItemCrud.create_or_update_bill_item()
    end)
  end
end

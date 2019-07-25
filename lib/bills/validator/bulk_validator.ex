defmodule Bills.Validator.BulkValidator do
  def reading_file(path, _separator) do
    File.stream!(path)
    |> CSV.decode(
      separator: ?;,
      headers: [
        :bill_number,
        :client_name,
        :client_last_name,
        :client_identification,
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
end

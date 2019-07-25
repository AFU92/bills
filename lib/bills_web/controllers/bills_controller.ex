defmodule BillsWeb.BillsController do
  alias Bills.Validator.BulkValidator
  use BillsWeb, :controller

  def bulk(conn, %{
        "file" => %Plug.Upload{content_type: "text/csv", filename: filename, path: path},
        "separator" => separator
      }) do
    case BulkValidator.reading_file(path, separator) do
      %{correct_data: data, error_data: []} ->
        json(conn, %{
          msg: "The file #{filename} has data",
          data: data
        })

      %{correct_data: _data, error_data: error} ->
        json(conn, %{
          msg: "The file #{filename} has errors",
          error: error
        })

        nil
    end
  end

  def bulk(
        conn,
        %{
          "file" => %Plug.Upload{content_type: content_type, filename: _filename, path: _path},
          "separator" => _separetor
        }
      ) do
    send_resp(conn, :bad_params, "Unsupported Content Type #{content_type}")
  end
end

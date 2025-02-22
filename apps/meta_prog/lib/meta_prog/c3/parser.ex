defmodule MetaProg.C3.MimeParser do
  @moduledoc false

  alias NimbleCSV.RFC4180, as: CSV

  @external_resource mime_csv =
                       :meta_prog
                       |> Application.fetch_env!(:project_root)
                       |> Path.join(["priv/init_mime.txt"])

  def run() do
    mime_csv
    |> File.stream!()
    |> CSV.parse_stream()
    |> Stream.map(fn [ext, kod, mime_type] ->
      [sanitize(ext), sanitize(kod), sanitize(mime_type)]
    end)
    |> Enum.group_by(fn [_, _, mime_type] ->
      mime_type
    end)
  end

  def sanitize(str) do
    str
    |> String.trim()
    |> String.downcase()
  end
end

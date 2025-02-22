defmodule MetaProg.C3.MimeText do
  @moduledoc false
  @external_resource mime_lines =
                       Path.join([
                         Application.compile_env!(:meta_prog, :project_root),
                         "priv/init_mime.txt"
                       ])

  for line <-
        mime_lines
        |> File.read!()
        |> String.split("\n", trim: true) do
    # Each line is a string, e.g. "image/jpeg\t.jpeg, .jpg"
    [type, rest] =
      line
      |> String.split(~r/\s+/, parts: 2)
      |> Enum.map(&String.trim/1)

    extensions = String.split(rest, ~r/,\s?/)

    def exts_from_type(unquote(type)), do: unquote(extensions)
    def type_from_ext(ext) when ext in unquote(extensions), do: unquote(type)
  end

  def exts_from_type(_type), do: []
  def type_from_ext(_ext), do: nil
  def valid_type?(type), do: exts_from_type(type) |> Enum.any?()
end

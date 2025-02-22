defmodule MetaProg.C3.Mime do
  @moduledoc false
  alias MetaProg.C3.MimeParser

  Enum.map(MimeParser.run(), fn [ext, kod, mime_type] ->
    nil
  end)

  defp gen_fn([ext, kod, mime_type]) do
    quote do
      @doc "#{unquote(kod)}"
      def ext2mime(ext), do: unquote(mime_type)
      def mime2ext(mime_type), do: unquote(ext)
    end
  end

  def ext2mime(_ext), do: nil
  def mime2ext(_mime_type), do: nil
end

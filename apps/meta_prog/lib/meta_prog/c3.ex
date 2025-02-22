defmodule MetaProg.C3 do
  require IEx

  def run() do
    File.cwd()
    |> elem(1)
    |> Path.join(["priv/media_types.html"])
    |> File.read!()
    |> Floki.parse_document()
    |> elem(1)
    |> traverse_tree
    |>Enum.filter(&Enum.count(&1)==3)
  end

  def traverse_tree(nodes_list) do
    find_html_node(nodes_list, [])
    # Floki.find(nodes_list, "table.tbody")
    # |> Enum.take(1)
    # IEx.pry()
  end

  def find_html_node([], acc), do: acc

  def find_html_node(nodes_list, acc) do
    # IEx.pry()

    IO.inspect(Enum.count(nodes_list))

    {children_nodes, new_acc} = list_tr(nodes_list, [])
    find_html_node(children_nodes, new_acc ++ acc)
    # IEx.pry()
  end

  def list_tr(nodes_list, acc) do
    Enum.reduce(nodes_list, {[], acc}, fn n, {cn, td_n} ->
      # IEx.pry()
      node(n, {cn, td_n})
    end)
  end

  # def node({"tr", _attributes, children_nodes}, {_, td_n}), do: {[], children_nodes ++ td_n}

  def node({"tbody", _attributes, children_nodes}, {_, td_n}), do: {[], td_n ++ [children_nodes]}
  # def node({"td", _attributes, children_nodes}, {_, td_n}), do: {[], children_nodes ++ td_n}
  # def node({"td", _attributes, children_nodes}), do: children_nodes
  # def node({"body", _attributes, children_nodes}), do: children_nodes
  def node({_tag_name, _attributes, children_nodes}, {cn, td_n}) do
    # IEx.pry()
    {children_nodes ++ cn, td_n}
  end

  def node(_, acc), do: acc

  def debug() do
    binding() |> Enum.each(fn {k, v} -> {IO.inspect(k), IO.inspect(v, limit: 10)} end)
  end
end

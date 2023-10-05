defmodule Algorithms.Tree do
  defmodule TreeNode do
    @type t :: %__MODULE__{
            val: integer,
            left: TreeNode.t() | nil,
            right: TreeNode.t() | nil
          }
    defstruct val: 0, left: nil, right: nil
  end

  @spec range_sum_bst(root :: TreeNode.t() | nil, low :: integer, high :: integer) :: integer
  def range_sum_bst(nil, _low, _high), do: 0

  def range_sum_bst(%{val: data, left: ln, right: rn}, low, high) do
    sum =
      if data >= low and data <= high do
        data
      else
        0
      end

    sum + range_sum_bst(ln, low, high) + range_sum_bst(rn, low, high)
  end

  @spec max_depth(root :: TreeNode.t() | nil) :: integer
  def max_depth(nil), do: 0

  def max_depth(%{left: left_node, right: right_node}) do
    1 + Kernel.max(max_depth(left_node), max_depth(right_node))
  end

  #     1. find diameter of current node , left SBT and right SBT
  # and take max of all 3.
  # 2. to find diameter of current node , height of LSBT and
  # RSBT. we add them we dont add one
  @spec diameter_of_binary_tree(root :: TreeNode.t() | nil) :: integer
  def diameter_of_binary_tree(nil), do: 0

  def diameter_of_binary_tree(%{left: ln, right: rn}) do
    #  max of current node diameter and left sbt and right sbt
    current_diameter = max_depth(ln) + max_depth(rn)

    [current_diameter, diameter_of_binary_tree(ln), diameter_of_binary_tree(rn)]
    |> Enum.max()
  end

  @spec is_balanced(root :: TreeNode.t() | nil) :: boolean
  def is_balanced(nil), do: true

  def is_balanced(%{left: left_node, right: right_node}) do
    Kernel.abs(max_depth(left_node) - max_depth(right_node)) <= 1 && is_balanced(left_node) &&
      is_balanced(right_node)
  end

  @spec has_path_sum(root :: TreeNode.t() | nil, target_sum :: integer) :: boolean
  def has_path_sum(nil, _), do: false

  def has_path_sum(%{right: rn, left: ln, val: val}, target_sum) do
    newTargetSum = target_sum - val

    case {newTargetSum == 0, rn == nil && ln == nil} do
      {true, true} -> true
      _ -> has_path_sum(ln, newTargetSum) or has_path_sum(rn, newTargetSum)
    end
  end

  @spec path_sum(root :: TreeNode.t() | nil, target_sum :: integer) :: [[integer]]
  def path_sum(root, target_sum) do
    ps(root, target_sum, [], [])
    |> Enum.map(&Enum.reverse/1)
  end

  def ps(nil, _, _, acc), do: acc

  def ps(%{left: nil, right: nil, val: lv}, val, path, acc) when lv == val,
    do: [[lv | path] | acc]

  def ps(%{left: nil, right: nil, val: val}, val, path, acc), do: acc

  def ps(%{left: ln, right: rn, val: val}, target_sum, path, acc) do
    newTargetSum = target_sum - val
    acc = ps(ln, newTargetSum, [val | path], acc)
    ps(rn, newTargetSum, [val | path], acc)
  end
end

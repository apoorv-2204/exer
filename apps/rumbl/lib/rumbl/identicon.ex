defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  @doc """
  Main
  string input from Identicon
  ## Exmapples

      iex>

  """
  def main(input) do
    input
    |> hash_string
    |> generate_color
  end

  @doc """
  Main
  string input from Identicon
  ## Exmapples

      iex> Identicon.main("banana")

  """
  def hash_string(input_string) do
    :crypto.hash(:md5, input_string)
    |> :binary.bin_to_list()
  end

  @doc """


    :crypto.hash(:md5 , input_string)#returns md5 string in binary
    |> :binary.bin_to_list #converts binary to list 

  ## Exmapples

      iex> Identicon.main("banana")

  """
  def hash_string(input_string) do
    :crypto.hash(:md5, input_string)
    |> :binary.bin_to_list()
  end
end

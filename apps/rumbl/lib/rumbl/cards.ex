defmodule Cards do
  #noexecuses get shit done
  @moduledoc """
  A module for creating deck,shuffling and creating a hand
  """

  @doc """
    To return a set of cards club diamond heart and spades
      #LIST ARE ACTUALLY LINKED LIST
      # INNERLOOPELEMENT <- INNERLOOP  OUTERLOOP ELEMENT <- OUTERLOOP  do
  """
  def create_deck do
    cards_name = ["Ace","two","three","four","five","six","seven","eight","nine","ten","Jack","Queen","King"]
    suits = ["Diamond","Heart","Spade","Club"]
    for suits_element <- suits , cards_element <- cards_name  do
      "#{cards_element} of #{suits_element}"
    end

  end


  def shuffle(deck_of_cards) do
     Enum.shuffle(deck_of_cards)
  end


  @doc """
    ? marks means it will return a boolean value
    It takes the set of cards and the card to be found as input
    Returns a boolean value
  ## Examapples

      iex>deck = Cards.create_deck
      iex>Cards.contains? deck,"Ace of Diamond"
      true

  """
  def contains?(deck_of_cards,card) do
   Enum.member?(deck_of_cards,card)
  end

  @doc """
    Divides a deck of cards into a hand of given size and rest of cards
    Takes a list of string of cards `deck_of_cards` , and `hand_size` indicates
    how many cards should be in hand
    .String matching is case sensitive
  ## Examples
      iex>deck=Cards.create_deck
      iex>{hand,_}=Cards.deal(deck,1)
      iex>hand
      ["Ace of Diamond"]

  """
  def deal(deck_of_cards,hand_size) do
      Enum.split(deck_of_cards,hand_size)
  end

  def save_file(filename,data) do
    binary_data=:erlang.term_to_binary(data);
    File.write  filename ,binary_data
  end

  def load_file(filename) do
    case File.read(filename) do
      {:ok,binary} -> :erlang.binary_to_term binary
      {:error,_  } -> " The file dont exist "
      #{:error,error_reason} ->
      #{:error,:enoent} ->
    end
  end

  def deal_hand(hand_size) do
      Cards.create_deck
      |>Cards.shuffle
      |>Cards.deal(hand_size)
  end
end

  # the name of the project will appear all
  #over the files in the project
  # #  modules
  #     Enum
  #     List
  # def helloWorld do
  #      "helloboi" <> "yeahhhhhboi/n"
  # end


# #Addressing the issue of comphrension inside comphrenison
    # #goal to get single list of string
    # #everyone in everything returns something
    # deck_of_cards=
    #       for suits_element <- suits do
    #           for cards_element <- cards_name do
    #             "#{cards_element} of #{suits_element}"
    #           end
    #       end

    # #flattens the list of list into a single list
    # List.flatten(deck_of_cards)
    # #array comphrension
    # #wrong approach As new arraylist inside anoter array/list
    # for suits_element <- suits do
    #     #Each comphrension works kind of a function
    #     #returning value of each  do end in comphrension is list of all output
    #     for cards_element <- cards_name do
    #       # deck=cards_element<>" of "<>suits_elements
    #       deck="#{cards_element} of #{suits_element}"
    #       #template literal
    #     end
    # end


  # def load_file(filename) do
  #   case File.read(filename) do
  #     {:ok,binary} -> :erlang.binary_to_term binary
  #     {:error,_  } -> " The file dont exist "
  #     #{:error,error_reason} ->
  #     #{:error,:enoent} ->
  #   end
  # end


  # def load_file(filename) do
  #   # IO.put_chars status
  #   # IO.put_chars binary_data
  #   #didnt work# {status,binary_data.legible_data}
  #   {status,binary_data}=File.read(filename)

  #   case status do
  #   :ok ->
  #     legible_data = :erlang.binary_to_term binary_data
  #   :error->
  #   legible_data = "The File Don't exist"
  #   end
  # end

  # def deal_hand(hand_size) do
  #     deck=Cards.create_deck()
  #     deck=Cards.shuffle(deck)
  #     {hand,rest} = Cards.deal(deck,hand_size)
  # end

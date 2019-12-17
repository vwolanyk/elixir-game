defmodule Hangman.Game do

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters:    [],
    used:       MapSet.new()
  )

  # #################### SERVER CODE

  use GenServer

  # this is like an api into the server code - this kicks off the
   # creates a new process that uses callbacks first is init

  def start_link()  do
    GenServer.start_link( __MODULE__, Dictionary.random_word)
  end

  def start_link(word)  do
    GenServer.start_link( __MODULE__, word)
  end

  def init(word) do
    {:ok, new_game(word) }
  end

  def handle_call({:make_move, guess}, _from, game) do
      { game, tally } = game_make_move(game, guess)
      { :reply, tally, game }
  end

  def handle_call({:tally}, _from, game) do
      { :reply, game_tally(game), game }
  end


  # ################# API CODE
  def rumble() do
    {:ok, pid } = Supervisor.start_child(Hangman.Supervisor, [])
    pid
  end

  def tally(game_pid) do
    GenServer.call(game_pid, {:tally})
  end

  def make_move(game_pid, guess) do
    GenServer.call(game_pid, {:make_move, guess})
  end


  # ################## GAME FUNCTIONALITY CODE

  defp new_game(word) do
    %Hangman.Game{ letters: word |> String.codepoints }
  end

  defp game_make_move(game = %{ game_state: state }, _guess) when state in [:won, :lost] do
    game
    |> return_game_and_tally
  end

  defp game_make_move(game, guess) do
    accept_move(game, guess, MapSet.member?(game.used, guess))
    |> return_game_and_tally
  end

  defp return_game_and_tally(game) do
    { game, game_tally(game) }
  end

  defp game_tally(game) do
    %{
      game_state:      game.game_state,
      turns_left:      game.turns_left,
      letters:         game.letters |> reveal_guessed(game.used),
      already_guessed: Enum.join( MapSet.to_list(game.used), ", ")
    }
  end

  defp accept_move(game, _guess, _already_used = true) do
    Map.put(game, :game_state, :already_used)
  end

  defp accept_move(game, guess, _not_already_used) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    new_state = MapSet.new(game.letters)
    |> MapSet.subset?(game.used)
    |> won?()
    Map.put(game, :game_state, new_state)
  end

  defp score_guess(game = %{ turns_left: 1 }, _wrong_guess) do
    Map.put(game, :game_state, :lost)
  end

  defp score_guess(game = %{ turns_left: turns_left }, _wrong_guess) do
    %{ game |
       game_state: :bad_guess,
       turns_left: (turns_left -  1)
    }
  end

  defp won?(true), do: :won
  defp won?(_false),    do: :good_guess

  defp reveal_guessed(game_letters, used_letters) do
    Enum.map(game_letters, fn letter -> reveal_letter?(letter, MapSet.member?(used_letters, letter))end)
  end

  defp reveal_letter?(letter, _should_reveal = true), do: letter
  defp reveal_letter?(_letter, _dont_reveal), do: "_"
end

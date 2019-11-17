defmodule Hangman.Game do

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters:    [],
    used:       MapSet.new()
  )

  def new_game(word) do
    %Hangman.Game{ letters: word |> String.codepoints }
  end

  def new_game() do
    new_game(Dictionary.random_word)
  end

  def make_move(game = %{ game_state: state }, _guess) when state in [:won, :lost] do
    game
    |> return_game_and_tally
  end

  def make_move(game, guess) do
    accept_move(game, guess, MapSet.member?(game.used, guess))
    |> return_game_and_tally
  end

  defp return_game_and_tally(game) do
    { game, tally(game) }
  end

  def tally(game) do
    %{
      game_state:      game.game_state,
      turns_left:      game.turns_left,
      letters:         game.letters |> reveal_guessed(game.used),
      already_guessed: Enum.join( MapSet.to_list(game.used), ", ")
    }
  end

  def accept_move(game, _guess, _already_used = true) do
    Map.put(game, :game_state, :already_used)
  end

  def accept_move(game, guess, _not_already_used) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  def score_guess(game, _good_guess = true) do
    new_state = MapSet.new(game.letters)
    |> MapSet.subset?(game.used)
    |> won?()
    Map.put(game, :game_state, new_state)
  end

  def score_guess(game = %{ turns_left: 1 }, _wrong_guess) do
    Map.put(game, :game_state, :lost)
  end

  def score_guess(game = %{ turns_left: turns_left }, _wrong_guess) do
    %{ game |
       game_state: :bad_guess,
       turns_left: (turns_left -  1)
    }
  end

  def won?(true), do: :won
  def won?(_false),    do: :good_guess

  def reveal_guessed(game_letters, used_letters) do
    Enum.map(game_letters, fn letter -> reveal_letter?(letter, MapSet.member?(used_letters, letter))end)
  end

  def reveal_letter?(letter, _should_reveal = true), do: letter
  def reveal_letter?(_letter, _dont_reveal), do: "_"
end

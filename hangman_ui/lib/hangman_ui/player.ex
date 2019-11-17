defmodule HangmanUi.Player do

  alias HangmanUi.{Prompter, State, Summary, Mover}

  # states: :initializing, :won, :lost, invalid_guess, :already_used, :bad_guess, :good_guess
  # :won
  def play(%State{tally: %{ game_state: :won}}) do
    exit_with_mssg("BullsEYE! Winner's Circle!")
  end

  # :lost
  def play(%State{tally: %{  game_service: %{ letters: full_word }, game_state: :lost}}) do
    exit_with_mssg("******--GAME--OVER--YOU--LOSE--********** #{full_word}")
  end

  # :already_used
  def play(game = %State{tally: %{ game_state: :already_used}}) do
    continue_with_message(game, "Duplicate Guess - Guess again")
  end

  # :good_guess
  def play(game = %State{ game_service: %{ letters: full_word }, tally: %{ game_state: :good_guess, letters: letters_guessed}}) do
    total_letters = Enum.count(full_word)
    total_guessed = Enum.count(letters_guessed, fn x -> x != "_" end)
    continue_with_message(game, "Great You have guessed #{total_guessed}! Only #{total_letters} to go!")
  end

  # :bad_guess
  def play(game = %State{ tally: %{ game_state: :bad_guess }}) do
    continue_with_message(game, "X -> WRONG <- X")
  end

  def play(game = %State{tally: %{ game_state: :initializing }}) do
    continue(game)
  end

  def continue_with_message(game, message) do
    IO.puts(message)
    continue(game)
  end

  def continue(game) do
    game
    |> Summary.display()
    |> Prompter.prompt_for_guess()
    |> Mover.make_move()
    |> play
  end

  defp exit_with_mssg(mssg) do
    IO.puts(mssg)
    exit(:normal)
  end
end

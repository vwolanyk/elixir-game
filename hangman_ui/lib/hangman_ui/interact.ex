defmodule HangmanUi.Interact do
  alias HangmanUi.{State, Player}

  def start() do
    Hangman.rumble()
    |> setup_state()
    |> Player.play()
  end

  def setup_state(game) do
    %State{
      game_service: game,
      tally: Hangman.tally(game)
    }
  end
end

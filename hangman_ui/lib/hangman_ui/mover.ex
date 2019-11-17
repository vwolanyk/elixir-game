defmodule HangmanUi.Mover do

  alias HangmanUi.State

  def make_move(game) do
    {game_service, tally} = Hangman.make_move(game.game_service, game.guessed)
    %State{ game | game_service: game_service, tally: tally }
  end
end

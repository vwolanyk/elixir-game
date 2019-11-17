defmodule HangmanUi.Summary do

  def display(game = %{ tally: tally }) do
    IO.puts [
      "\n",
      "Word so far: #{Enum.join(tally.letters, " ")}\n ",
      "Guesses Left: #{tally.turns_left}\n ",
      "Already Guessed: #{tally.already_guessed}\n"
    ]
    game
  end
end

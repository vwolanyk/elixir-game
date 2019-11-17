defmodule HangmanUi.Prompter do
  def prompt_for_guess(game) do
    IO.gets("Hit me with your best guess: ")
    |> check_input(game)
  end

  defp check_input({ :error, reason }, _) do
    IO.puts("Game Over? #{reason}")
    exit(:normal)
  end

  defp check_input(:eof, _) do
    IO.puts("Giving up so soon?")
    exit(:normal)
  end

  defp check_input(input, game) do
    input = String.trim(input)
    cond do
      input =~ ~r/\A[a-z]\z/ ->
        updated_game = Map.put(game, :guessed, input)
        Map.put(game.game_service, :game_state, :proactive)
        updated_game
      true ->
        IO.puts "invalid guess, enter single lowercase letter"
        prompt_for_guess(game)
    end
  end
end

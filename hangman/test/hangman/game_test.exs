defmodule Hangman.GameTest do
  use ExUnit.Case
  alias Hangman.Game

  test "assert new game initialized" do
    new_game = Game.new_game
    assert new_game.game_state == :initializing
    assert new_game.turns_left == 7
    assert length(new_game.letters) > 0
  end

  test "letter are lowecase ascii" do
    new_game = Game.new_game
    assert String.match?( List.to_string(new_game.letters), ~r/^[[:lower:][:ascii:]]+$/)
  end

  test "game won or lost " do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert {game, _} = Game.make_move(game, "y")
    end
  end

  test "first occurance of guess" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "2nd occurance returns already_used game_state" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "win a game with all the right guesses" do
    game = Game.new_game("mettle")
    {game, _tally} = Game.make_move(game, "m")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    {game, _tally} = Game.make_move(game, "e")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    {game, _tally} = Game.make_move(game, "t")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    {game, _tally} = Game.make_move(game, "l")
    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "validates single character string as guess" do
    game = Game.new_game("mettle")
    {game, _tally} = Game.make_move(game, "xxx")
    assert game.game_state == :bad_guess
  end

  test "sees bad guess and decrements turns" do
    game = Game.new_game("mettle")
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "lost game state when out of turns" do
    game = Game.new_game("p")
           |> Map.put(:turns_left, 1)
    IO.inspect(game)
    {game, _tally} = Game.make_move(game, "l")
    IO.inspect(game)
    assert game.game_state == :lost
  end
end

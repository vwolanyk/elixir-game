defmodule Hangman.Server do
  use GenServer
  alias Hangman.Game

  # this is like an api into the server code - this kicks off the
   # creates a new process that uses callbacks first is init

  def start_link()  do
    GenServer.start_link( __MODULE__, nil)
  end

  def init(_) do
    {:ok, Game.new_game() }
  end

  def handle_call({:make_move, guess}, _from, game) do
      { game, tally } = Game.make_move(game, guess)
      { :reply, tally, game }
  end

  def handle_call({:tally}, _from, game) do
      { :reply, Game.tally(game), game }
  end

end

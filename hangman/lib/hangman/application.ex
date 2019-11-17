defmodule Hangman.Application do
  use Application
  use Supervisor

  def start(_type, _args) do
    children = [
      worker(Hangman.Game, [])
    ]

    options = [
      name: Hangman.Supervisor,
      strategy: :simple_one_for_one
    ]

    Supervisor.start_link(children, options)
  end
end

defmodule Dictionary.Application do
  use Application
  use Supervisor

  def start(_type, _args) do
    children = [
      worker(Dictionary.WordGenerator, [])
    ]

    options = [
      name: Dictionary.Supervisor,
      strategy: :one_for_one
    ]

    Supervisor.start_link(children, options)
  end
end

defmodule HangmanUi do
  defdelegate start(), to: HangmanUi.Interact
end

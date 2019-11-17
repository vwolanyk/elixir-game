defmodule HangmanUiTest do
  use ExUnit.Case
  doctest HangmanUi

  test "greets the world" do
    assert HangmanUi.hello() == :world
  end
end

defmodule Dictionary.WordGenerator do

  def start_link() do
    Agent.start_link(fn -> word_list(); end, name: __MODULE__)
  end

  def random_word() do
    Agent.get(__MODULE__, &Enum.random/1)
  end

  def word_list do
    Dictionary.WordList.word_list()
  end
end

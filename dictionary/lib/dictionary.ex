defmodule Dictionary do

  alias Dictionary.{WordList, WordGenerator}

  defdelegate start(), to: WordList, as: :word_list
  defdelegate random_word(), to: WordGenerator
end

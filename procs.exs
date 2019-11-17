defmodule Procs do
  def greeter(count) do
    receive do
      {:add, n} ->
        count = count + n
        greeter(count)
      {:reset} ->
        count = 0
        greeter(count)
      mssg ->
        IO.puts "**#{count}: Hey  #{mssg}"
        greeter(count + 1)
    end
  end
end

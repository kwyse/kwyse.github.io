defmodule Mix.Tasks.Build do
  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    {us, :ok} = :timer.tc(fn -> PersonalWebsite.build() end)
    ms = us / 1000
    IO.puts("Built in #{ms}ms")
  end
end

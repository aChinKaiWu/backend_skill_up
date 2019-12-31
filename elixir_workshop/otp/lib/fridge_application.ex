defmodule FridgeApplication do
  use Application

  def start(_, _) do
    children = [{FridgeSupervisor, []}]
    Supervisor.start_link(children, strategy: :one_for_one, name: Fride)
  end
end

defmodule FridgeSupervisor do
  use Supervisor

  # Public Api
  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Callbacks
  def init(_) do
    children = [{FridgeServer, []}]
    Supervisor.init(children, strategy: :one_for_one)
  end
end

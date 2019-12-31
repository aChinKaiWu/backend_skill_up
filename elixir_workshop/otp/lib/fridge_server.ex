defmodule FridgeServer do
  use GenServer

  # Public Api
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def look() do
    GenServer.call(__MODULE__, :look_inside)
  end

  def take(item) do
    GenServer.call(__MODULE__, {:take, item})
  end

  def put(item) do
    GenServer.cast(__MODULE__, {:put, item})
  end

  def clean() do
    GenServer.call(__MODULE__, :clean_out)
  end

  def kick() do
    GenServer.cast(__MODULE__, :broke)
  end

  # Callbacks
  def init(_) do
    {:ok, []}
  end

  def handle_call(:look_inside, _, state) do
    {:reply, inspect(state), state}
  end

  def handle_call(:clean_out, _, state) do
    {:reply, inspect(state), []}
  end

  def handle_call({:take, item}, _, state) do
    if item in state do
      {:reply, item, List.delete(state, item)}
    else
      {:reply, :not_in_fridge, state}
    end
  end

  def handle_cast({:put, item}, state) do
    {:noreply, [item | state]}
  end

  def handle_cast(:broke, _) do
    Process.exit(self(), :kill)
  end
end

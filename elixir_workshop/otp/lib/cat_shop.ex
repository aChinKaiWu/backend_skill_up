defmodule CatShop do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  # Synchronous call
  def order_cat(pid, %Cat{name: name, color: color, description: description} = _cat) do
    GenServer.call(pid, {:order, name, color, description})
  end

  # Asynchronous call
  def return_cat(pid, %Cat{} = cat) do
    GenServer.cast(pid, {:return, cat})
  end

  # Synchronous call
  def close_shop(pid) do
    GenServer.stop(pid)
  end

  @impl true
  def init(cats) do
    {:ok, cats}
  end

  @impl true
  def handle_call({:order, _name, _color, _description}, _from, [cat | tail]) do
    {:reply, cat, tail}
  end

  @impl true
  def handle_call({:order, name, color, description}, _from, []) do
    cat = %Cat{name: name, color: color, description: description}
    {:reply, cat, []}
  end

  @impl true
  def terminate(:normal, cats) do
    for cat <- cats, do: IO.inspect("#{cat.name} was set free.")
    {:shutdown, cats}
  end

  @impl true
  def handle_cast({:return, cat}, cats) do
    {:noreply, [cat | cats]}
  end
end

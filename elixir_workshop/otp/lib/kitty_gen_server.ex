defmodule KittyGenServer do
  use GenServer

  defmodule Cat do
    defstruct name: nil, color: :black, description: nil
  end

  # ------------------------------------------------------------------------------
  # Client API
  # ------------------------------------------------------------------------------

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Synchronous call
  def order_cat(name, color, description) do
    GenServer.call(__MODULE__, {:order, name, color, description})
  end

  # Synchronous call
  def close_shop() do
    GenServer.call(__MODULE__, :terminate)
  end

  # Asynchronous call
  def return_cat(%Cat{} = cat) do
    GenServer.cast(__MODULE__, {:return, cat})
  end

  # ------------------------------------------------------------------------------
  # GenServer Callbacks
  # ------------------------------------------------------------------------------

  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def handle_call({:order, name, color, description}, _from, cats) do
    case cats do
      [] ->
        {:reply, make_cat(name, color, description), cats}
      [cat | tail] ->
        {:reply, cat, tail}
    end
  end

  def handle_call(:terminate, _from, cats) do
    {:stop, :normal, :ok, cats}
  end

  @impl true
  def handle_cast({:return, %Cat{} = cat}, cats) do
    {:noreply, [cat | cats]}
  end

  @impl true
  def terminate(:normal, cats) do
    for cat <- cats, do: IO.inspect("#{cat.name} was set free.")
    :ok
  end

  defp make_cat(name, color, description) do
    %Cat{name: name, color: color, description: description}
  end
end

defmodule CatShopApplication do
  use Application

  def start(_type, _args) do
    children = [
      {CatShopSupervisor, strategy: :one_for_one, name: CatShopSupervisor}
    ]

    Supervisor.start_link(children, strategy: :rest_for_one, name: __MODULE__)
  end
end

defmodule Bills.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Bills.Repo

  def item_factory do
    %Bills.Schema.Item{
      name: sequence(:name, &"A item #{&1}"),
      description: sequence(:description, &"Cute item #{&1}"),
      price: 77.5,
      code: sequence(:code, &"Abc#{&1}")
    }
  end
end

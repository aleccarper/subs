defmodule Subs.GameObject do
  defstruct id: nil, module: nil, data: nil
  
  def new(module, data) do
    obj = %__MODULE__{id: UUID.uuid1(), module: module, data: data}
    Subs.Game.add_game_object(obj)
  end

  def update(obj, game_state) do
    Map.merge(obj, %{data: obj.module.update(obj.data, game_state)})
  end
end
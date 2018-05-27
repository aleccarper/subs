defmodule Subs.Sub do
  defstruct player_id: nil, position: %{x: 0.0, y: 0.0}
  
  def new(player_id) do
    obj = %__MODULE__{player_id: player_id, position: %{x: 0.0, y: 0.0}}
    Subs.GameObject.new(__MODULE__, obj)
    obj
  end

  def update(sub, game_state) do
    sub |>
    movement_update(game_state) |>
    network_update(game_state)
  end

  def movement_update(sub, game_state) do
    Map.merge(sub, %{position: %{x: sub.position.x + 2 * game_state.delta_time(), y: sub.position.y}})
  end

  def network_update(sub, game_state) do
    SubsWeb.Endpoint.broadcast!("game", "sub:move", sub)
    sub
  end
end
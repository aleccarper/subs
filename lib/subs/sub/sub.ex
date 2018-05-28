defmodule Subs.Sub do
  defstruct player_id: nil, position: %{x: 0, y: 0}, direction: %{x: 0, y: 0}, speed: 2
  
  alias Graphmath.Vec2

  def new(player_id) do
    obj = %__MODULE__{player_id: player_id}
    Subs.GameObject.new(__MODULE__, obj)
    obj
  end

  def start_direction(sub, direction) do
    new_direction = cond do
      direction == "left" -> %{ x: -1, y: sub.direction.y }
      direction == "right" -> %{ x: 1, y: sub.direction.y }
      direction == "down" -> %{ x: sub.direction.x, y: -1 }
      direction == "up" -> %{ x: sub.direction.x, y: 1 }
    end
    Map.merge(sub, %{direction: new_direction})
  end

  def end_direction(sub, direction) do
    new_direction = cond do
      direction == "left" -> %{ x: 0, y: sub.direction.y }
      direction == "right" -> %{ x: 0, y: sub.direction.y }
      direction == "down" -> %{ x: sub.direction.x, y: 0 }
      direction == "up" -> %{ x: sub.direction.x, y: 0 }
    end
    Map.merge(sub, %{direction: new_direction})
  end

  def update(sub, game_state) do
    sub |>
    movement_update(game_state) |>
    network_update(game_state)
  end

  def movement_update(sub, game_state) do
    if {0, 0} == {sub.direction.x, sub.direction.y} do
      sub
    else
      {pos_x, pos_y} =
        {sub.direction.x, sub.direction.y} |>
        Vec2.normalize |>
        Vec2.scale(sub.speed * game_state.delta_time) |>
        Vec2.add({sub.position.x, sub.position.y})

      
      Map.merge(sub, %{position: %{x: pos_x, y: pos_y}}) |> IO.inspect
    end
  end

  def network_update(sub, game_state) do
    SubsWeb.Endpoint.broadcast!("game", "sub:move", sub)
    sub
  end
end
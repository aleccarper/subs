defmodule Subs.Sub do
  defstruct player_id: nil, position: %{x: 0, y: 0}, direction: %{x: 0, y: 0}, target_direction: %{x: 0, y: 0}, speed: 0, max_speed: 3, propulsion: 0.75, drift: 0.35
  
  alias Graphmath.Vec2
  alias Subs.Utils
  
  def new(player_id) do
    sub = %__MODULE__{player_id: player_id}
    Subs.Game.add_sub(sub)
    sub
  end

  def start_direction(sub, direction) do
    new_direction = cond do
      direction == "left" -> %{ x: -1, y: sub.target_direction.y }
      direction == "right" -> %{ x: 1, y: sub.target_direction.y }
      direction == "down" -> %{ x: sub.target_direction.x, y: -1 }
      direction == "up" -> %{ x: sub.target_direction.x, y: 1 }
    end
    Map.merge(sub, %{target_direction: new_direction})
  end

  def end_direction(sub, direction) do
    new_direction = cond do
      direction == "left" -> %{ x: 0, y: sub.target_direction.y }
      direction == "right" -> %{ x: 0, y: sub.target_direction.y }
      direction == "down" -> %{ x: sub.target_direction.x, y: 0 }
      direction == "up" -> %{ x: sub.target_direction.x, y: 0 }
    end
    Map.merge(sub, %{target_direction: new_direction})
  end

  def update(sub, game_state) do
    sub |>
    interpolation_update(game_state) |>
    movement_update(game_state) |>
    network_update(game_state)
  end

  defp interpolation_update(sub, game_state) do
    if {0, 0} == {sub.target_direction.x, sub.target_direction.y} do
      %{ 
        sub | 
        direction: Utils.interpolate_floats(sub.direction, sub.target_direction, sub.drift * game_state.delta_time),
        speed: Utils.interpolate_floats(sub.speed, 0, sub.drift * game_state.delta_time)
      }
    else
      %{ 
        sub | 
        direction: Utils.interpolate_floats(sub.direction, sub.target_direction, sub.propulsion * game_state.delta_time),
        speed: Utils.interpolate_floats(sub.speed, sub.max_speed, sub.propulsion * game_state.delta_time)
      }
    end
  end

  defp movement_update(sub, game_state) do
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

  defp network_update(sub, game_state) do
    SubsWeb.Endpoint.broadcast!("game", "sub:move", sub)
    sub
  end
end
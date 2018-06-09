defmodule Subs.Torpedo do
  defstruct id: nil, position: %{x: 0, y: 0}, direction: %{x: 0, y: 0}, target_direction: %{x: 0, y: 0}, speed: 0, max_speed: 5, propulsion: 1.25, life_time: 0.0
  
  alias Graphmath.Vec2
  alias Subs.Utils
  
  def new(start_direction, target_direction) do
    torpedo = %__MODULE__{direction: start_direction, target_direction: target_direction}
    Subs.Game.add_torpedo(torpedo)
    torpedo
  end

  def update(torpedo, game_state) do
    torpedo |>
    interpolation_update(game_state) |>
    movement_update(game_state) |>
    network_update(game_state)
  end

  defp interpolation_update(torpedo, game_state) do
    %{ 
      torpedo | 
      direction: Utils.interpolate_floats(torpedo.direction, torpedo.target_direction, torpedo.propulsion * game_state.delta_time),
      speed: Utils.interpolate_floats(torpedo.speed, torpedo.max_speed, torpedo.propulsion * game_state.delta_time)
    }
  end

  defp movement_update(torpedo, game_state) do
    {pos_x, pos_y} =
      {torpedo.direction.x, torpedo.direction.y} |>
      Vec2.normalize |>
      Vec2.scale(torpedo.speed * game_state.delta_time) |>
      Vec2.add({torpedo.position.x, torpedo.position.y})

    
    Map.merge(torpedo, %{position: %{x: pos_x, y: pos_y}})
  end

  defp network_update(torpedo, game_state) do
    SubsWeb.Endpoint.broadcast!("game", "torpedo:move", torpedo)
    torpedo
  end
end
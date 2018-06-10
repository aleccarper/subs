defmodule Subs.GameState do
  defstruct game_objects: %{}, last_loop: 0, delta_time: 0.0

  alias Subs.{Sub, Utils}
  
  def new do
    %__MODULE__{last_loop: Utils.time_now()}
  end

  def update(state) do
    state |>
    start_update |>
    run_updates
  end

  def add_game_object(state, game_object) do
    %{state | game_objects: Map.merge(state.game_objects, %{game_object.id => game_object})}
  end

  def fire_torpedo(state, sub_id, direction) do
    updated_game_objects = %{state.game_objects | sub_id => state.game_objects[sub_id] |> Sub.fire_torpedo(direction)}
    %{state | game_objects: updated_game_objects}
  end

  def change_direction(state, type, sub_id, direction) when type == :start do
    updated_game_objects = %{state.game_objects | sub_id => state.game_objects[sub_id] |> Sub.start_direction(direction)}
    %{state | game_objects: updated_game_objects}
  end

  def change_direction(state, type, sub_id, direction) when type == :end do
    updated_game_objects = %{state.game_objects | sub_id => state.game_objects[sub_id] |> Sub.end_direction(direction)}
    %{state | game_objects: updated_game_objects}
  end

  defp start_update(state) do
    dt = (Utils.time_now() - state.last_loop) / 1000
    Map.merge(state, %{delta_time: dt, last_loop: Utils.time_now()})
  end

  def run_updates(state) do
    updated_game_objects = state.game_objects |> 
    Enum.map(fn({key, game_object}) -> {key, game_object.__struct__.update(game_object, state)} end) |>
    Enum.into(%{})
    %{state | game_objects: updated_game_objects}
  end
end
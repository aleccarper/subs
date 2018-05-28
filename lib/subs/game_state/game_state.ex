defmodule Subs.GameState do
  defstruct game_objects: [], last_loop: 0, delta_time: 0.0

  alias Subs.Utils
  
  def new do
    %__MODULE__{last_loop: Utils.time_now()}
  end

  def update(state) do
    state |>
    start_update |>
    update_game_objects
  end

  def add_game_object(state, obj) do
    Map.merge(state, %{game_objects: [obj | state.game_objects]})
  end

  def update_direction(state, type, player_id, direction) do
    game_objects = state.game_objects |> Enum.map(fn(obj) ->
      if obj.module == Subs.Sub && obj.data.player_id == player_id do
        if type == :start do
          Map.merge(obj, %{data: Subs.Sub.start_direction(obj.data, direction) })
        else
          Map.merge(obj, %{data: Subs.Sub.end_direction(obj.data, direction) })
        end
      else
        obj
      end
    end)
    Map.merge(state, %{game_objects: game_objects})
  end

  defp start_update(state) do
    dt = (Utils.time_now() - state.last_loop) / 1000
    Map.merge(state, %{delta_time: dt, last_loop: Utils.time_now()})
  end

  def update_game_objects(state) do
    updated_game_objects = state.game_objects |> Enum.map(fn(obj) -> 
      Subs.GameObject.update(obj, state)
    end)
    Map.merge(state, %{game_objects: updated_game_objects})
  end
end
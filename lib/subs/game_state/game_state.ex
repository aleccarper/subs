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
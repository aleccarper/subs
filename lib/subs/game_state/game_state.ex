defmodule Subs.GameState do
  defstruct subs: %{}, last_loop: 0, delta_time: 0.0

  alias Subs.{Sub, Utils}
  
  def new do
    %__MODULE__{last_loop: Utils.time_now()}
  end

  def update(state) do
    state |>
    start_update |>
    update_subs
  end

  def add_sub(state, sub) do
    new_subs = Map.merge(state.subs, %{sub.player_id => sub})
    %{state | subs: new_subs}
  end

  def change_direction(state, type, player_id, direction) when type == :start do
    updated_subs = %{state.subs | player_id => state.subs[player_id] |> Sub.start_direction(direction)}
    %{state | subs: updated_subs}
  end

  def change_direction(state, type, player_id, direction) when type == :end do
    updated_subs = %{state.subs | player_id => state.subs[player_id] |> Sub.end_direction(direction)}
    %{state | subs: updated_subs}
  end

  defp start_update(state) do
    dt = (Utils.time_now() - state.last_loop) / 1000
    Map.merge(state, %{delta_time: dt, last_loop: Utils.time_now()})
  end

  def update_subs(state) do
    new_subs = state.subs |> 
    Enum.map(fn({key, sub}) -> {key, Sub.update(sub, state)} end) |>
    Enum.into(%{})
    %{state | subs: new_subs}
  end
end
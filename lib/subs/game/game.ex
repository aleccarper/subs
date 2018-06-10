defmodule Subs.Game do
  use GenServer

  alias Subs.GameState
  alias Subs.Utils

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: :game_manager)
  end

  def add_game_object(game_object) do
    GenServer.cast(:game_manager, {:add_game_object, game_object})
  end

  def update_direction(type, player_id, direction) do
    GenServer.cast(:game_manager, {:update_direction, type, player_id, direction})
  end

  def fire_torpedo(player_id, direction) do
    GenServer.cast(:game_manager, {:fire_torpedo, player_id, direction})
  end

  ### SERVER ###

  def init([]) do
    state = GameState.new
    schedule_loop(state)
    {:ok, state}
  end

  def handle_info(:loop, state) do
    state = GameState.update(state)
    schedule_loop(state)
    {:noreply, state}
  end

  def handle_cast({:add_game_object, game_object}, state) do
    state =  GameState.add_game_object(state, game_object)
    {:noreply, state}
  end

  def handle_cast({:fire_torpedo, player_id, direction}, state) do
    state =  GameState.fire_torpedo(state, player_id, direction)
    {:noreply, state}
  end

  def handle_cast({:update_direction, type, player_id, direction}, state) do
    {:noreply, GameState.change_direction(state, type, player_id, direction)}
  end

  defp schedule_loop(state) do
    next = 30 - ((Utils.time_now() - state.last_loop) / 1000) |> round
    Process.send_after(self(), :loop, next)
  end
end
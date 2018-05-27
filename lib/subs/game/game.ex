defmodule Subs.Game do
  use GenServer

  alias Subs.GameState
  alias Subs.Utils

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: :game_manager)
  end

  def add_game_object(obj) do
    GenServer.cast(:game_manager, {:add_game_object, obj})
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

  def handle_cast({:add_game_object, obj}, state) do
    state =  GameState.add_game_object(state, obj)
    {:noreply, state}
  end

  defp schedule_loop(state) do
    next = 30 - ((Utils.time_now() - state.last_loop) / 1000) |> round
    Process.send_after(self(), :loop, next)
  end
end
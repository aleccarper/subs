defmodule Subs.Game do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: :game_manager)
  end

  def add_game_object(obj) do
    GenServer.cast(:game_manager, {:add_game_object, obj})
  end

  def delta_time() do
    GenServer.call(:game_manager, {:delta_time})
  end

  ### SERVER ###

  def init([]) do
    state = %{game_objects: [], last_loop: time_now(), delta_time: 0.0}
    schedule_loop(state)
    {:ok, state}
  end

  def handle_info(:loop, state) do
    state = Map.merge(
      state, 
      %{
        delta_time: (time_now() - state[:last_loop]) / 1000,
        last_loop: time_now()
      }
    )
    state = process_loop(state)
    schedule_loop(state)
    {:noreply, state}
  end

  def handle_cast({:add_game_object, obj}, state) do
    state =  Map.merge(state, %{game_objects: [obj | state[:game_objects]]})

    {:noreply, IO.inspect(state)}
  end

  def handle_call({:delta_time}, _from, state) do
    {:reply, state[:delta_time], state}
  end

  defp process_loop(state) do
    updated_game_objects = state[:game_objects] |> Enum.map(fn(obj) -> 
      Subs.GameObject.update(obj, state)
    end)
    Map.merge(state, %{game_objects: updated_game_objects})
  end

  defp schedule_loop(state) do
    next = 30 - ((time_now() - state[:last_loop]) / 1000) |> round
    Process.send_after(self(), :loop, next)
  end

  defp time_now() do
    :os.system_time(:milli_seconds)
  end
end
defmodule SubsWeb.GameChannel do
  use Phoenix.Channel

  def join("game", player_id, socket) do
    Subs.Sub.new(player_id) |> IO.inspect
    {:ok, socket}
  end
  
  def handle_in("sub:start_direction", %{"player_id" => player_id, "direction" => direction}, socket) do
    Subs.Game.update_direction(:start, player_id, direction)
    {:noreply, socket}
  end

  def handle_in("sub:end_direction", %{"player_id" => player_id, "direction" => direction}, socket) do
    Subs.Game.update_direction(:end, player_id, direction)
    {:noreply, socket}
  end

end
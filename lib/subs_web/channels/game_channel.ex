defmodule SubsWeb.GameChannel do
  use Phoenix.Channel

  def join("game", player_id, socket) do
    Subs.Sub.new(player_id) |> IO.inspect
    {:ok, socket}
  end
  
end
defmodule PlacePlaceWeb.RoomChannel do
  use PlacePlaceWeb, :channel

  @impl true
  def join("room:lobby", payload, socket) do
    {:ok, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("draw", payload, socket) do
    broadcast(socket, "draw", payload)
    {:noreply, socket}
  end
end

defmodule PlacePlace.Canvas do
  use GenServer

  defmodule Config do
    defstruct width: 100,
              height: 100
  end

  defmodule DrawRequest do
    defstruct [:position, :color]
  end

  @impl true
  def init(config) do
    {:ok,
     %{
       config: config,
       canvas: %{}
     }}
  end

  @impl true
  def handle_call({:lookup, position}, _from, state) do
    config = state.config

    with :ok <- validate_position(position, config.width, config.height) do
      got = Map.fetch(state.canvas, position)
      {:reply, {:ok, got}, state}
    else
      error_tuple -> {:reply, error_tuple, state}
    end
  end

  @impl true
  def handle_call(:dump, _from, state) do
    {:reply, state}
  end

  @impl true
  def handle_call({:draw, draw_request}, _from, state) do
    config = state.config
    req = draw_request

    with :ok <- validate_position(req.position, config.width, config.height),
         :ok <- validate_color(req.color) do
      {:reply, Map.put(state.canvas, req.position, req.color)}
    else
      error_tuple -> {:reply, error_tuple, state}
    end
  end

  @spec validate_color(String.t()) :: :ok | {:error, String.t()}
  defp validate_color(color) do
    hex_regex = ~r/^#(?:[0-9a-fA-F]{3}){1,2}$/

    if Regex.match?(hex_regex, color) do
      :ok
    else
      {:error, "invalid hex color: #{color}"}
    end
  end

  @spec validate_position(
          {non_neg_integer(), non_neg_integer()},
          non_neg_integer(),
          non_neg_integer()
        ) :: :ok | {:error, String.t()}
  defp validate_position({x, y} = _position, width, height) do
    if x < width or y < height do
      :ok
    else
      {:error, "invalid position: (#{x}, #{y})"}
    end
  end
end

defmodule Subs.Utils do
  
  def time_now() do
    :os.system_time(:milli_seconds)
  end

  def interpolate_floats(value, target, delta) when is_map(value) do
    value |>
    Enum.map(fn({key, val}) -> {key, interpolate_floats(val, target[key], delta)} end) |>
    Enum.into(%{})
  end
  def interpolate_floats(value, target, delta) do
    value + delta * (target - value)
  end
  
end
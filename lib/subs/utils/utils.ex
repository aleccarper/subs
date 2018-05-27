defmodule Subs.Utils do
  
  def time_now() do
    :os.system_time(:milli_seconds)
  end

end
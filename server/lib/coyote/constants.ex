defmodule Coyote.Constants do
  defmacro __using__(_) do
    quote do
      @user_channel_cache :user_channel_cache
    end
  end
end
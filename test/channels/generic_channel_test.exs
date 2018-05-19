defmodule Coyote.UserChannelTest do
  use Coyote.ChannelCase

  alias Coyote.UserChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(UserChannel, "public:1")

    {:ok, socket: socket}
  end

  test "brodcast_from payload at channel", %{socket: socket} do
    push socket, "broadcast", %{"hey" => "there"}
    assert_broadcast "broadcast", %{"hey" => "there"}
  end

  test "brodcast payload at channel", %{socket: socket} do
    push socket, "broadcast!", %{"hey" => "there"}
    assert_broadcast "broadcast!", %{"hey" => "there"}
  end
end
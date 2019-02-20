defmodule CryptoLadderTest do
  use ExUnit.Case
  doctest CryptoLadder

  test "greets the world" do
    assert CryptoLadder.hello() == :world
  end

  test "script running crypto ladder" do
    {:ok, pid} = CryptoLadder.start

    IO.puts("ping binance")
    CryptoLadder.ping_binance(pid)
    |> IO.inspect

    IO.puts("time binance")
    CryptoLadder.get_time_binance(pid)
    |> IO.inspect

    IO.puts("all prices from binance")
    CryptoLadder.get_all_prices_binance(pid)
    |> IO.inspect


  end
end

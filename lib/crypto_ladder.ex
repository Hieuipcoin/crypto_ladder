defmodule CryptoLadder do
  use GenServer

  @endpoint "https://api.binance.com"

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def cast(crypto_ladder) do
    GenServer.cast(crypto_ladder, {:cast, "from cast"})
  end

  def ping_binance(pid) do
    GenServer.call(pid, :ping_binance)
  end

  def get_time_binance(pid) do
    GenServer.call(pid, :time_binance)
  end

  @impl true
  def init(_) do
    IO.puts("from init")
    {:ok, "from init"}
  end

  defp get_binance(url, headers \\ []) do
    HTTPoison.get("#{@endpoint}#{url}", headers)
    |> parse_get_response
  end

  defp parse_get_response({:ok, response}) do
    response.body
    |> Poison.decode()
    |> parse_response_body
  end

  defp parse_get_response({:error, err}) do
    {:error, {:http_error, err}}
  end

  defp parse_response_body({:ok, data}) do
    case data do
      %{"code" => _c, "msg" => _m} = error -> {:error, error}
      _ -> {:ok, data}
    end
  end

  defp parse_response_body({:error, err}) do
    {:error, {:poison_decode_error, err}}
  end

  @impl GenServer
  def handle_cast({:cast, string_cast}, _state) do
    IO.puts("riki handle cast: #{string_cast}")
    {:noreply, ""}
  end

  @impl GenServer
  def handle_call(:ping_binance, _, state) do
    result = get_binance("/api/v1/ping")
    {
      :reply,
      result,
      state
    }
  end

  @impl GenServer
  def handle_call(:time_binance, _, state) do
    result = case get_binance("/api/v1/time") do
      {:ok, %{"serverTime" => time}} -> {:ok, time}
      err -> err
    end

    {
      :reply,
      result,
      state
    }
  end





end

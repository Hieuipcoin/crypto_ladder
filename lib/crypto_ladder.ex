defmodule CryptoLadder do
  use GenServer

  @endpoint "https://api.binance.com"

  def hello do
    :world
  end

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

  def get_all_prices_binance(pid) do
    GenServer.call(pid, :all_prices)
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
    {:ok, ping} = get_binance("/api/v1/ping")
    {
      :reply,
      ping,
      state
    }
  end

  @impl GenServer
  # riki temporary ignore error return. impl later. ^^
  def handle_call(:time_binance, _, state) do
    {:ok, %{"serverTime" => time}} = get_binance("/api/v1/time")
    {
      :reply,
      time,
      state
    }
  end

  @impl GenServer
  # riki temporary ignore error return. impl later. ^^
  def handle_call(:all_prices, _, state) do
    {:ok, data} = get_binance("/api/v1/ticker/allPrices")
    data = Enum.map(data, &Binance.SymbolPrice.new(&1))
    {
      :reply,
      data,
      state
    }
  end





end

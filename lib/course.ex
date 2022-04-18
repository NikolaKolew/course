defmodule Course do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # client side
  # @spec state :: any()
  def state do
    GenServer.call(__MODULE__, :get_state)
  end

  # @spec add(any) :: :ok
  def add(username, email, password, sex) do
    user = %User{
      username: username,
      email: email,
      password: password,
      is_logged_in: false,
      sex: sex
    }

    GenServer.cast(__MODULE__, {:add, user})
  end

  # @spec init(any) :: {:ok, any}
  def init(init_args) do
    {:ok, init_args}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:add, elem}, state) do
    {:noreply, [elem | state]}
  end
end

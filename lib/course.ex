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

  def get_user(username) do
    GenServer.call(__MODULE__, {:get_user, username})
  end

  def login(username, password) do
    GenServer.call(__MODULE__, {:login, username, password})
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

  def delete(username) do
    GenServer.cast(__MODULE__, {:delete, username})
  end

  # @spec init(any) :: {:ok, any}
  def init(init_args) do
    {:ok, init_args}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_user, username}, _from, state) do
    {:reply, Enum.filter(state, fn x -> x.username == username end), state}
  end

  def handle_call({:login, username, password}, _from, state) do
    user = Enum.filter(state, fn x -> x.username == username && x.password == password end)

    {:reply, user, state}
  end

  def handle_cast({:add, elem}, state) do
    {:noreply, [elem | state]}
  end

  def handle_cast({:delete, username}, state) do
    new_state = Enum.reject(state, fn x -> x.username == username end)
    {:noreply, new_state}
  end
end

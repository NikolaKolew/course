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
  def add(first_name, last_name, email, password) do
    user = %User{
      first_name: first_name,
      last_name: last_name,
      email: email,
      password: password
    }

    GenServer.cast(__MODULE__, {:add, user})
  end

  # @spec init(any) :: {:ok, any}
  def init(init_args) do
    {:ok, init_args}
  end

  def handle_call(:break, _from, state) do
    {:reply, 1 / 0, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:add, elem}, state) do
    {:noreply, [elem | state]}
  end

  def handle_cast({:remove, elem}, state) do
    {:noreply, Enum.filter(state, fn e -> e != elem end)}
  end
end

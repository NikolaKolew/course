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

  def logout do
    GenServer.call(__MODULE__, :logout)
  end

  def get_user(username) do
    GenServer.call(__MODULE__, {:get_user, username})
  end

  def login(username, password) do
    GenServer.call(__MODULE__, {:login, username, password})
  end

  # @spec add(any) :: :ok
  def create(username, email, password, sex) do
    user = %User{
      username: username,
      email: email,
      password: password,
      is_logged_in: false,
      sex: sex
    }

    GenServer.call(__MODULE__, {:create, user})
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

  def handle_call(:logout, _from, state) do
    isAnyoneLogged = Enum.any?(state, fn x -> x.is_logged_in == true end)

    indexOfUser =
      if isAnyoneLogged do
        Enum.find_index(state, fn x -> x.is_logged_in == true end)
      else
        nil
      end

    state =
      if indexOfUser != nil do
        List.update_at(state, indexOfUser, fn x -> Map.put(x, :is_logged_in, false) end)
      else
        state
      end

    result =
      if indexOfUser != nil do
        "Successfull logout"
      else
        "No logged user"
      end

    {:reply, result, state}
  end

  def handle_call({:get_user, username}, _from, state) do
    {:reply, Enum.filter(state, fn x -> x.username == username end), state}
  end

  def handle_call({:login, username, password}, _from, state) do
    # add complex validation not just success/failed
    isAnyoneLogged = Enum.any?(state, fn x -> x.is_logged_in == true end)

    indexOfUser =
      if isAnyoneLogged == false do
        Enum.find_index(state, fn x -> x.username == username && x.password == password end)
      else
        nil
      end

    state =
      if indexOfUser != nil do
        List.update_at(state, indexOfUser, fn x -> Map.put(x, :is_logged_in, true) end)
      else
        state
      end

    result =
      if indexOfUser != nil do
        "Sucess"
      else
        "Failed"
      end

    {:reply, result, state}
  end

  def handle_call({:create, elem}, _from, state) do
    # add error if there is a user with the same username or email(now the mothod dont change the state when this happens)
    new_state =
      if Enum.any?(state, fn x -> x.username == elem.username || x.email == elem.email end) do
        state
      else
        [elem | state]
      end

    error =
      if Enum.any?(state, fn x -> x.username == elem.username || x.email == elem.email end) do
        "A user with this email or username already exist!"
      else
        "You successfully created a new user!"
      end

    {:reply, error, new_state}
  end

  def handle_cast({:delete, username}, state) do
    new_state = Enum.reject(state, fn x -> x.username == username end)
    {:noreply, new_state}
  end
end

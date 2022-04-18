defmodule User do
  @enforce_keys [:username, :email, :password, :is_logged_in, :sex]
  defstruct @enforce_keys

  def user_info(%User{username: username, email: email}) do
    "#{username} #{email}"
  end
end

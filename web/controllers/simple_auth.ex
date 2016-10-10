defmodule PasswordlessLoginApp.SimpleAuth do
  import Plug.Conn
  alias PasswordlessLoginApp.{Repo, User}

  # def init(opts), do: opts

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    assign_current_user(conn, user_id)
  end

  defp assign_current_user(conn, nil) do
    assign(conn, :current_user, nil)
  end

  defp assign_current_user(conn, user_id) do
    user = Repo.get(User, user_id)
    assign(conn, :current_user, user)
  end

  def logout(conn) do
    conn |> configure_session(drop: true)
  end
end

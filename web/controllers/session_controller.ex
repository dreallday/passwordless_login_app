defmodule PasswordlessLoginApp.SessionController do
  use PasswordlessLoginApp.Web, :controller
  alias PasswordlessLoginApp.User


  def new(conn, _params) do
    changeset = User.changeset(%User{})
    conn
    |> render("new.html", changeset: changeset)
  end

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, %{"user" => user_params}) do
    user_email = String.downcase(user_params["email"])
    user_struct =
      case Repo.get_by(User, email: user_email) do
        nil -> %User{email: user_email}
        user -> user
      end
      |> User.registration_changeset(user_params)
    case Repo.insert_or_update(user_struct) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "We sent you a link to create an account, Plx check your email")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => access_token}) do
    case Repo.get_by(User, access_token: access_token) do
      nil ->
        conn
        |> put_flash(:error, "Access token not found, lel")
        |> redirect(to: page_path(conn, :index))
      user ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Welcome #{user.email}")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> PasswordlessLoginApp.SimpleAuth.logout()
    |> put_flash(:info, "User logged out!")
    |> redirect(to: page_path(conn, :index))
  end
end

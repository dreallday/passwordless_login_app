defmodule PasswordlessLoginApp.Mailer do
  import Bamboo.Email

  alias PasswordlessLoginApp.{Endpoint, Router, User}
  use Bamboo.Mailer, otp_app: :passwordless_login_app

  def send_login_token(%User{email: email, access_token: token}) do
    new_email(
      to: email,
      from: "noreply@dre.today",
      subject: "Your Login Token",
      html_body: "Access your account #{token_url(token)}"
    )
  end

  defp token_url(token) do
    Router.Helpers.session_url(Endpoint, :show, token)
  end

end

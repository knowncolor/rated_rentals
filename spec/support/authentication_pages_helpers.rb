require 'spec_helper'

module SignInHelpers

  def valid_signin(user)
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

  def invalid_signin
    click_button "Sign in"
  end

  def sign_out
    click_link "Sign out"
  end

end
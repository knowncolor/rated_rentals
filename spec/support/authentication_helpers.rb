
include Warden::Test::Helpers
Warden.test_mode!

def valid_signin(user=nil)
  user = FactoryGirl.create(:user) if !user

  visit new_user_session_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password

  click_button "Sign in"

  user
end
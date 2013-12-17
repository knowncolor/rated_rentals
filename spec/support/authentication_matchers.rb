# match signed out navigation links
RSpec::Matchers.define :require_login do
  match do |page|
    expect(page).should have_selector('div.alert', 'You need to sign in before continuing.')
  end
end
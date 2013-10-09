
# match error message flash
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

# match signed out navigation links
RSpec::Matchers.define :be_signed_out do
  match do |page|
    expect(page).should have_link('Sign in')
  end
end
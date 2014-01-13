FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password 'changeme'
    password_confirmation 'changeme'
  end
end
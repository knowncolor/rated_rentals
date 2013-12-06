# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    street_number "MyString"
    route "MyString"
    postal_town "MyString"
    locality "MyString"
    country "MyString"
    postal_code "MyString"
    postal_code_prefix "MyString"
  end
end

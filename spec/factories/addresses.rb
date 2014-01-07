# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    flat_number "flat number 1"
    street_number "street number 1"
    route "route 1"
    postal_town "town 1"
    postal_code "postal 1"
    country "country 1"
    decimal_degrees_latitude 52.12123
    decimal_degrees_longitude 4.12123
  end
end

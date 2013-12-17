# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    street_number "MyString"
    route "MyString"
    postal_town "MyString"
    postal_code "MyString"
    decimal_degrees_latitude 52.12123
    decimal_degrees_longitude 4.12123
    start_date "03/04/2013"
    end_date "03/04/2015"
    building_rating 5
    building_comments "building comments"
    furnishings_rating 6
    furnishings_comments "furnishings comments"
    noise_rating 7
    noise_comments "noise comments"
    amenities_rating 8
    amenities_comments "amenities comments"
    transport_rating 9
    transport_comments "transport comments"
  end
end

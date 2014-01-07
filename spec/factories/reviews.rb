# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
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
    association :address, factory: :address
  end
end

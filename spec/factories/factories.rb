def create_user(attributes = {})
  user = new_user(attributes)
  user.save
  user
end

def new_user(attributes = {})
  attributes = user_attributes(attributes)
  User.new(attributes)
end

def user_attributes(attributes = {})
  attributes[:name] ||=Faker::Name.name
  attributes[:email] ||= Faker::Internet.email
  attributes[:password] ||= 'password'
  attributes[:password_confirmation] ||= 'password'

  attributes
end

def user_attributes_for(user)
  user.attributes.delete_if do |k, v|
    ["id", "type", "created_at", "updated_at"].member?(k)
  end
end

def create_address(attributes = {})
  address = new_address(attributes)
  address.save
  address
end

def new_address(attributes = {})
  attributes = address_attributes(attributes)

  Address.new(attributes)
end

def address_attributes(attributes = {})
  attributes[:flat_number] ||= Faker::Address.building_number
  attributes[:street_number] ||= Faker::Address.building_number
  attributes[:route] ||= Faker::Address.street_name
  attributes[:postal_town] ||= Faker::Address.city
  attributes[:postal_code] ||= Faker::Address.zip_code
  attributes[:country] ||= Faker::Address.country
  attributes[:decimal_degrees_latitude] ||= Faker::Address.latitude
  attributes[:decimal_degrees_longitude] ||= Faker::Address.longitude

  attributes
end

def address_attributes_for(address)
  address.attributes.delete_if do |k, v|
    ["id", "type", "created_at", "updated_at"].member?(k)
  end
end


def create_review(attributes = {})
  review = new_review(attributes)
  review.save
  review
end

def new_review(attributes = {})
  attributes = review_attributes(attributes)

  attributes[:user] ||= new_user
  attributes[:address] ||= new_address

  Review.new(attributes)
end

def review_attributes(attributes = {})
  attributes[:start_date] ||= "03/04/2013"
  attributes[:end_date] ||= "03/08/2013"
  attributes[:building_rating] ||= 1
  attributes[:building_comments] ||= "building comments"
  attributes[:furnishings_rating] ||= 2
  attributes[:furnishings_comments] ||= "furnishings comments"
  attributes[:noise_rating] ||= 3
  attributes[:noise_comments] ||= "noise comments"
  attributes[:amenities_rating] ||= 4
  attributes[:amenities_comments] ||= "amenities comments"
  attributes[:transport_rating] ||= 5
  attributes[:transport_comments] ||= "transport comments"

  attributes
end

def review_attributes_for(review)
  review.attributes.delete_if do |k, v|
      ["id", "type", "address_id", "user_id", "created_at", "updated_at"].member?(k)
  end
end
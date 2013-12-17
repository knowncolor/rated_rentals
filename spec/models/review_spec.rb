require 'spec_helper'

describe Review do
  before do
    @review = FactoryGirl.create(:review)
  end

  subject { @review }

  it { should respond_to(:street_number) }
  it { should respond_to(:route) }
  it { should respond_to(:postal_town) }
  it { should respond_to(:postal_code) }
  it { should respond_to(:decimal_degrees_latitude) }
  it { should respond_to(:decimal_degrees_longitude) }
  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }
  it { should respond_to(:building_rating) }
  it { should respond_to(:building_comments) }
  it { should respond_to(:furnishings_rating) }
  it { should respond_to(:furnishings_comments) }
  it { should respond_to(:noise_rating) }
  it { should respond_to(:noise_comments) }
  it { should respond_to(:amenities_rating) }
  it { should respond_to(:amenities_comments) }
  it { should respond_to(:transport_rating) }
  it { should respond_to(:transport_comments) }

  it { should be_valid }

  describe "when street number is not present" do
    before { @review.street_number = " " }
    it { should_not be_valid }
  end

  describe "when route is not present" do
    before { @review.route = " " }
    it { should_not be_valid }
  end

  describe "when postal town is not present" do
    before { @review.postal_town = " " }
    it { should_not be_valid }
  end

  describe "when postal_code is not present" do
    before { @review.postal_code = " " }
    it { should_not be_valid }
  end

  describe "when start_date is not present" do
    before { @review.start_date = nil }
    it { should_not be_valid }
  end
end

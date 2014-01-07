require 'spec_helper'

describe Review do
  before do
    @review = FactoryGirl.create(:review)
  end

  subject { @review }

  it { should respond_to(:address) }
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

  describe "validations" do
    describe "when start_date is not present" do
      before { @review.start_date = nil }
      it { should_not be_valid }
    end

    describe "when an address is not present" do
      before { @review.address = nil }
      it { should_not be_valid }
    end
  end

  describe "address association" do
    let(:address) { FactoryGirl.create(:address) }

    it "should be settable and retrievable" do
      @review.address = address
      @review.save

      expect(@review.reload.address.id).to eq address.id
    end

    it "should accept nested attributes for the address" do
      should accept_nested_attributes_for :address
    end

    it "should fail validation if a nested address fails validation" do
      @review.address = address
      should be_valid
      address.route = nil
      should_not be_valid
    end
  end

  describe "user association" do
    let(:user) { FactoryGirl.create(:user) }

    it "should be settable and retrievable" do
      @review.user = user
      @review.save

      expect(@review.reload.user.id).to eq user.id
    end
  end

  describe "formatted address" do
    it "should combine the flat, house, street, town, and postcode" do
      expect(@review.formatted_address).to eq "#{@review.address.flat_number}, #{@review.address.street_number} #{@review.address.route}, #{@review.address.postal_town}, #{@review.address.postal_code}"
    end

    it "should combine the house, street, town, and postcode if flat not present" do
      @review.address.flat_number = nil
      expect(@review.formatted_address).to eq "#{@review.address.street_number} #{@review.address.route}, #{@review.address.postal_town}, #{@review.address.postal_code}"
    end

    it "should combine the house, street, town, and postcode if flat is blank" do
      @review.address.flat_number = ''
      expect(@review.formatted_address).to eq "#{@review.address.street_number} #{@review.address.route}, #{@review.address.postal_town}, #{@review.address.postal_code}"
    end
  end
end

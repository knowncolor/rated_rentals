require 'spec_helper'

describe Address do
  before do
    @address = create_address()
  end

  subject { @address }

  it { should respond_to(:reviews) }

  it { should respond_to(:flat_number) }
  it { should respond_to(:street_number) }
  it { should respond_to(:route) }
  it { should respond_to(:postal_town) }
  it { should respond_to(:postal_code) }
  it { should respond_to(:country) }
  it { should respond_to(:decimal_degrees_latitude) }
  it { should respond_to(:decimal_degrees_longitude) }
  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }
  it { should be_valid }

  describe "when street number is not present" do
    before { @address.street_number = " " }
    it { should_not be_valid }
  end

  describe "when route is not present" do
    before { @address.route = " " }
    it { should_not be_valid }
  end

  describe "when postal town is not present" do
    before { @address.postal_town = " " }
    it { should_not be_valid }
  end

  describe "when postal_code is not present" do
    before { @address.postal_code = " " }
    it { should_not be_valid }
  end

  describe "formatted address" do
    it "should combine the flat (formatted as 'Flat X'), house, street, and town" do
      expect(@address.formatted_address).to eq "Flat #{@address.flat_number}, #{@address.street_number} #{@address.route}, #{@address.postal_town}".titleize
    end

    it "should combine the house, street, and town if flat not present" do
      @address.flat_number = nil
      expect(@address.formatted_address).to eq "#{@address.street_number} #{@address.route}, #{@address.postal_town}".titleize
    end

    it "should combine the house, street, and town, if flat is blank" do
      @address.flat_number = ''
      expect(@address.formatted_address).to eq "#{@address.street_number} #{@address.route}, #{@address.postal_town}".titleize
    end

    it "should not add an extra 'Flat' string if already present" do
      @address.flat_number = 'Flat A'
      expect(@address.formatted_address).to eq "#{@address.flat_number}, #{@address.street_number} #{@address.route}, #{@address.postal_town}".titleize
    end
  end

  describe "reviews association" do
    it "should be settable and retrievable" do
      review1 = create_review()
      review2 = create_review()
      @address.reviews << review1
      @address.reviews << review2
      @address.save

      expect(@address.reload.reviews.count).to eq 2
    end
  end
end

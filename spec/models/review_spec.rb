require 'spec_helper'

describe Review do
  before do
    @review = create_review()
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
  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }

  describe "validations" do
    describe "when start_date is not present" do
      before { @review.start_date = nil }
      it { should_not be_valid }
    end

    describe "when an address is not present" do
      before { @review.address = nil }
      it { should_not be_valid }
    end

    describe "when user is not present" do
      before { @review.user = nil }
      it { should_not be_valid }
    end

    describe "ratings must be between 1..10" do
      context "ratings too low" do
        before do
          @review.building_rating = -1
          @review.furnishings_rating = -1
          @review.noise_rating = -0
          @review.amenities_rating = -100
          @review.transport_rating = -1
          @review.valid?
        end

        it "should have 5 validation errors" do
          expect(@review.errors.size).to eq 5
        end
      end

      context "ratings too high" do
        before do
          @review.building_rating = 11
          @review.furnishings_rating = 11
          @review.noise_rating = 100
          @review.amenities_rating = 11
          @review.transport_rating = 11
          @review.valid?
        end

        it "should have 5 validation errors" do
          expect(@review.errors.size).to eq 5
        end
      end

      context "ratings just right" do
        before do
          @review.building_rating = 1
          @review.furnishings_rating = 1
          @review.noise_rating = 10
          @review.amenities_rating = 1
          @review.transport_rating = 1
          @review.valid?
        end

        it { should be_valid }
      end
    end
  end

  describe "address association" do
    let(:address) { create_address() }

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

  describe "review word count" do
    it "should be the count of all the desciptions" do
      expect(@review.descriptions_word_count).to eq 10
    end
  end

  describe "user association" do
    let(:user) { create_user() }

    it "should be settable and retrievable" do
      @review.user = user
      @review.save

      expect(@review.reload.user.id).to eq user.id
    end
  end
end

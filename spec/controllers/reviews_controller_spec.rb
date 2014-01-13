require 'spec_helper'

include Devise::TestHelpers

describe ReviewsController do

  describe "GET #show" do
    it "assigns the requested contact to @contact" do
      review = FactoryGirl.create(:review)
      get :show, id: review
      assigns(:review).should eq(review)
    end

    it "renders the #show view" do
      get :show, id: FactoryGirl.create(:review)
      response.should render_template :show
    end
  end

  describe "POST create" do
    before do
      sign_in FactoryGirl.create(:user)
    end

    context "with valid attributes" do
      it "creates a new review" do
        expect {
          post :create, review: FactoryGirl.attributes_for(:review).merge(address_attributes: FactoryGirl.attributes_for(:address))
        }.to change(Review, :count).by(1)
      end

      it "redirects to the new review" do
        @attributes = FactoryGirl.attributes_for(:review).merge(address_attributes: FactoryGirl.attributes_for(:address))
        post :create, review: @attributes
        response.should redirect_to Review.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new review" do
        expect {
          post :create, review: FactoryGirl.attributes_for(:review, start_date: "fdkjfh").merge(address_attributes: FactoryGirl.attributes_for(:address))
        }.to_not change(Review, :count)
      end

      it "re-renders the new method" do
        post :create, review: FactoryGirl.attributes_for(:review, start_date: "fdkjfh").merge(address_attributes: FactoryGirl.attributes_for(:address))
        response.should render_template :new
      end
    end

    context "with address not matching an existing one" do
      it "creates a new address" do
        expect {
          post :create, review: FactoryGirl.attributes_for(:review).merge(address_attributes: FactoryGirl.attributes_for(:address))
        }.to change(Address, :count).by(1)
      end
    end

    context "with an address which matches an existing one" do
      it "match on all fields" do
        expect {
          FactoryGirl.create(:address).save
          post :create, review: FactoryGirl.attributes_for(:review).merge(address_attributes: FactoryGirl.attributes_for(:address))
        }.to change(Address, :count).by(1)
      end

      it "match only on required fields" do
        expect {
          FactoryGirl.create(:address, country: "new country", postal_town: "new postal town")
          post :create, review: FactoryGirl.attributes_for(:review).merge(address_attributes: FactoryGirl.attributes_for(:address))
        }.to change(Address, :count).by(1)
      end

      it "matching blank flat numbers" do
        expect {
          FactoryGirl.create(:address, flat_number: nil)
          post :create, review: FactoryGirl.attributes_for(:review).merge(address_attributes: FactoryGirl.attributes_for(:address, flat_number: nil))
        }.to change(Address, :count).by(1)
      end
    end

    context "with an address which doesnt match an existing one" do
      it "doesnt match on flat number" do
        expect {
          FactoryGirl.create(:address, flat_number: "new flat number")
          post :create, review: FactoryGirl.attributes_for(:review).merge(address_attributes: FactoryGirl.attributes_for(:address))
        }.to change(Address, :count).by(2)
      end

      it "doesnt match on street number" do
        expect {
          FactoryGirl.create(:address, street_number: "new street number")
          post :create, review: FactoryGirl.attributes_for(:review).merge(address_attributes: FactoryGirl.attributes_for(:address))
        }.to change(Address, :count).by(2)
      end

      it "doesnt match on route" do
        expect {
          FactoryGirl.create(:address, route: "new street")
          post :create, review: FactoryGirl.attributes_for(:review).merge(address_attributes: FactoryGirl.attributes_for(:address))
        }.to change(Address, :count).by(2)
      end

      it "doesnt match on postal_code number" do
        expect {
          FactoryGirl.create(:address, postal_code: "new postal code")
          post :create, review: FactoryGirl.attributes_for(:review).merge(address_attributes: FactoryGirl.attributes_for(:address))
        }.to change(Address, :count).by(2)
      end

      it "existing flat number is nil" do
        expect {
          FactoryGirl.create(:address, flat_number: nil)
          post :create, review: FactoryGirl.attributes_for(:review).merge(address_attributes: FactoryGirl.attributes_for(:address))
        }.to change(Address, :count).by(2)
      end

      it "new flat number is nil" do
        expect {
          FactoryGirl.create(:address)
          post :create, review: FactoryGirl.attributes_for(:review).merge(address_attributes: FactoryGirl.attributes_for(:address, flat_number: nil))
        }.to change(Address, :count).by(2)
      end
    end
  end
end

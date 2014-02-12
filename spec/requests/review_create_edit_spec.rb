require 'spec_helper'
include ReviewsHelper

describe "Review create and edit pages" do

  subject { page }
  let (:review) { create_review }
  let(:user) { review.user }

  describe "create a new review" do
    before do
      valid_signin user
      visit new_review_path
    end

    let(:submit) { "Save Review" }

    it { should have_content('Write A Review') }
    it { should have_content('Save Review') }
    it { should_not have_content('Cancel') }

    describe "with empty fields" do
      it "should not create a review" do
        expect { click_button submit }.not_to change(Review, :count)
      end

      it "should show validation error messages" do
        click_button submit
        should have_content('Please fix the')
      end
    end

    describe "with invalid start and end date formats" do
      it "should show a relevant error message" do
        fill_in "Moved In", with: "fkjdgfd"
        fill_in "Moved Out", with: "fkjdgfd"
        click_button submit

        should have_selector('li', text: 'Moved In Date is invalid')
        should have_selector('li', text: 'Moved Out Date is invalid')
      end
    end

    describe "with future moved in date" do
      it "should show a relevant error message" do
        fill_in "Moved In", with: "02/02/2100"
        click_button submit

        should have_selector('li', text: 'Moved In Date cannot be in the future')
      end
    end

    describe "with moved out date before moved in date" do
      it "should show a relevant error message" do
        fill_in "Moved In", with: "02/02/2011"
        fill_in "Moved Out", with: "02/02/2010"
        click_button submit

        should have_selector('li', text: 'Moved Out Date can\'t be before the Moved In date')
      end
    end

    describe "with valid information" do
      before do
        fill_in 'review_address_attributes_street_number', with: "75"
        fill_in 'review_address_attributes_route', with: "Whipps Cross Rd"
        fill_in 'review_address_attributes_postal_town', with: "London"
        fill_in 'review_address_attributes_postal_code', with: "E11 1NJ"
        fill_in 'review_start_date', with: "02/02/2011"
      end

      it "should create a review" do
        expect { click_button submit }.to change(Review, :count).by(1)
      end

      it "should have an associated user_id" do
        click_button submit
        expect(Review.last.user_id).to eq user.id
      end
    end
  end

  describe "edit a review" do
    before do
      valid_signin user
      visit edit_review_path review
    end

    let(:submit) { "Save Review" }

    it { should have_content('Edit Review') }
    it { should have_content('Save Review') }
    it { should have_content('Cancel') }

    # not possible without capybara running js
    describe "address fields should not be editable" do
      #it { should have_field('review_address_attributes_flat_number', disabled: true)}
      #it { should have_selector 'select[id=review_address_attributes_house_number]', disabled: true }
      #it { should have_selector 'select[id=review_address_attributes_flat_number][disabled]' }
      #it { should have_selector 'select[id=review_address_attributes_route][disabled]' }
      #it { should have_selector 'select[id=review_address_attributes_postal_town][disabled]' }
      #it { should have_selector 'select[id=review_address_attributes_postal_code][disabled]' }
    end

    describe "setting a field to empty" do
      it "should show validation error messages" do
        fill_in "review_address_attributes_postal_code", with: ""
        click_button submit
        should have_content('Please fix the')
      end
    end

    describe "with updated information" do
      let(:new_street_number) { "new street number" }
      let(:new_building_rating) { 1 }

      before do
        fill_in 'review_address_attributes_street_number', with: new_street_number
        fill_in 'review_building_rating', with: new_building_rating
      end

      it "should update the review" do
        click_button submit
        review.reload
        expect(review.address.street_number).to eq new_street_number
        expect(review.building_rating).to eq new_building_rating
      end

      it "should create a new address for the updated address" do
        click_button submit

        old_review_address_id = review.address_id
        review.reload
        new_review_address_id = review.address_id

        expect(old_review_address_id).to_not eq new_review_address_id
      end

      it "should keep its current user_id" do
        click_button submit
        expect(review.reload.user_id).to eq user.id
      end
    end
  end
end

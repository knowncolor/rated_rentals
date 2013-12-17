require 'spec_helper'

describe "Review create and edit pages" do

  subject { page }

  describe "new review page" do
    before do
      valid_signin
      visit new_review_path
    end

    it { should have_content('Write A Review') }
  end

  describe "create a new review" do
    before do
      valid_signin
      visit new_review_path
    end

    let(:submit) { "Save Review" }

    describe "with empty fields" do
      it "should not create a review" do
        expect { click_button submit }.not_to change(Review, :count)
      end

      it "should show validation error messages" do
        click_button submit
        should have_content('The form contains')
      end
    end

    describe "with invalid start and end date formats" do
      it "should show a relevant error message" do
        fill_in "Moved In",      with: "fkjdgfd"
        fill_in "Moved Out",      with: "fkjdgfd"
        click_button submit

        should have_selector('li', text: 'Moved In date is invalid')
        should have_selector('li', text: 'Moved Out date is invalid')
      end
    end

    describe "with future moved in date" do
      it "should show a relevant error message" do
        fill_in "Moved In",      with: "02/02/2100"
        click_button submit

        should have_selector('li', text: 'Moved In date cannot be in the future')
      end
    end

    describe "with moved out date before moved in date" do
      it "should show a relevant error message" do
        fill_in "Moved In",      with: "02/02/2011"
        fill_in "Moved Out",      with: "02/02/2010"
        click_button submit

        should have_selector('li', text: 'Moved Out date can\'t be before the Moved In date')
      end
    end

    describe "with valid information" do
      before do
        fill_in "House Number",  with: "75"
        fill_in "Street",        with: "Whipps Cross Rd"
        fill_in "Town or City",  with: "London"
        fill_in "Postal Code",   with: "E11 1NJ"
        fill_in "Moved In",      with: "02/02/2010"
      end

      it "should create a review" do
        expect { click_button submit }.to change(Review, :count).by(1)
      end

      describe "after saving the review" do
        before { click_button submit }
        let(:review) { Review.find_by(start_date: "02/02/2010") }

        it { should have_content('View Review') }
      end
    end
  end
end

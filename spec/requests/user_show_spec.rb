require 'spec_helper'

describe "User show pages" do

  subject { page }

  describe "viewing a user" do
    before do
      @user = valid_signin
      visit user_path @user
    end

    describe "header should have users name and joined date" do
      it { should have_content(@user.name) }
      it { should have_content(@user.created_at.to_formatted_s(:day_month_year)) }
    end

    context "profile page should look the same as the show user page" do
      before do
        visit account_path
      end
      it { should have_content("You haven't written any reviews yet") }
    end

    describe "should show a list of that users reviews" do
      let (:user2) { FactoryGirl.create(:user) }

      context "when they have no reviews" do
        context "for the current user" do
          it { should have_content("You haven't written any reviews yet") }
        end

        context "for a different user" do
          before do
            visit user_path user2
          end
          it { should have_content("This user has not written any reviews yet.") }
        end
      end

      context "when they have reviews" do
        let (:review1) { FactoryGirl.create(:review) }
        let (:review2) { FactoryGirl.create(:review) }
        let (:review3) { FactoryGirl.create(:review) }
        let (:review4) { FactoryGirl.create(:review) }

        before do
          @user.reviews << review1
          @user.reviews << review2
          user2.reviews << review3
          user2.reviews << review4
          @user.save
          user2.save
        end

        context "for the current user" do
          before { visit user_path @user }
          it { should_not have_content("You haven't written any reviews yet") }

          it "should show a summary of each review" do
            should have_content(review1.address.formatted_address)
            should have_content(review2.address.formatted_address)
          end
        end

        context "for a different user" do
          before { visit user_path user2 }
          it { should_not have_content("This user has not written any reviews yet.") }

          it "should show a summary of each review" do
            should have_content(review3.address.formatted_address)
            should have_content(review4.address.formatted_address)
          end
        end
      end

    end
  end
end

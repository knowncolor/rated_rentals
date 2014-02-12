require 'spec_helper'

describe "User show pages" do

  subject { page }

  describe "viewing a user" do
    before do
      @user = create_user
      valid_signin @user
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
      let (:user2) { create_user }

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
        let (:review1) { create_review }
        let (:review2) { create_review(building_rating: 10) }
        let (:review3) { create_review }
        let (:review4) { create_review }

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

          it { should have_link(review1.address.formatted_address, review_path(review1)) }

          it "should show a summary of each review" do
            should have_content(review1.address.formatted_address)
            should have_content(review2.address.formatted_address)

            should have_css("ol.reviews li ul.scores span.heat#{review1.building_rating}", :text => "Building")
            should have_css("ol.reviews li ul.scores span.score", :text => review1.building_rating)
            should have_css("ol.reviews li ul.scores span.heat#{review1.noise_rating}", :text => "Noise")
            should have_css("ol.reviews li ul.scores span.score", :text => review1.noise_rating)
            should have_css("ol.reviews li ul.scores span.heat#{review1.amenities_rating}", :text => "Amenities")
            should have_css("ol.reviews li ul.scores span.score", :text => review1.amenities_rating)
            should have_css("ol.reviews li ul.scores span.heat#{review1.transport_rating}", :text => "Transport")
            should have_css("ol.reviews li ul.scores span.score", :text => review1.transport_rating)
          end

          it "should have the edit and delete links" do
            should have_link('Edit', edit_review_path(review1))
            should have_link('Delete', review_path(review1))
          end

          it "if score is 10 it should be shown inside the heat span" do
            should have_css("ol.reviews li ul.scores span.heat#{review1.building_rating}", :text => "Building")
            should have_css("ol.reviews li ul.scores span span.score", :text => review1.building_rating)
          end
        end

        context "for a different user" do
          before { visit user_path user2 }
          it { should_not have_content("This user has not written any reviews yet.") }

          it "should show a summary of each review" do
            should have_content(review3.address.formatted_address)
            should have_content(review4.address.formatted_address)
          end

          it "should not have the edit and delete links" do
            should_not have_link('Edit', edit_review_path(review3))
            should_not have_link('Delete', review_path(review3))
          end
        end
      end

    end
  end
end

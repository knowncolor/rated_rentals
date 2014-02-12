require 'spec_helper'
include ReviewsHelper

describe "Review show pages" do

  subject { page }

  describe "viewing a review" do
    before do
      @review = create_review
      valid_signin @review.user

      visit review_path @review
    end

    context "owned by the current user" do
      describe "header should have address and link to own profile" do
        it { should have_content(@review.address.formatted_address) }
        it { should have_link('You', account_path) }
      end

      it "should have the edit and delete links" do
        should have_link('Edit', edit_review_path(@review))
        should have_link('Delete', review_path(@review))
      end
    end

    context "owned by the a different user" do
      before do
        @non_owned_review = create_review
        visit review_path @non_owned_review
      end

      describe "header should have address creators name" do
        it { should have_content(@non_owned_review.address.formatted_address) }
        it { should have_content(@non_owned_review.user.name) }
      end

      it "should not have the edit and delete links" do
        should_not have_link('Edit', edit_review_path(@review))
        should_not have_link('Delete', review_path(@review))
      end
    end
  end
end

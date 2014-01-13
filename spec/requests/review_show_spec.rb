require 'spec_helper'
include ReviewsHelper

describe "Review show pages" do

  subject { page }

  describe "viewing a review" do
    before do
      @user = valid_signin
      @review = FactoryGirl.create(:review)
      @review.user = @user
      @review.save

      visit review_path @review
    end

    describe "header should have address and user.name" do
      it { should have_content(review_title(@review)) }
      it { should have_content(@review.user.name) }
    end
  end
end

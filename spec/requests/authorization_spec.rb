require 'spec_helper'
include Devise::TestHelpers

describe 'authorization required pages' do
  let(:review) { create_review }
  let(:user) { review.user }

  subject { page }

  # requires sign-in
  # reviews [new, create, edit, update, delete], /account
  describe "non-signed-in users should be redirected to sign-in page" do
    describe "reviews" do
      describe "reviews#new" do
        before { visit new_review_path }
        it { should require_login }
      end

      describe "reviews#create" do
        before { post reviews_path }
        specify { expect(response).to redirect_to(new_user_session_path) }
      end

      describe "reviews#edit" do
        before { visit edit_review_path(review) }
        it { should require_login }
      end

      describe "reviews#update" do
        before { patch review_path(review) }
        specify { expect(response).to redirect_to(new_user_session_path) }
      end

      describe "reviews#update" do
        before { put review_path(review) }
        specify { expect(response).to redirect_to(new_user_session_path) }
      end

      describe "reviews#destroy" do
        before { delete review_path(review) }
        specify { expect(response).to redirect_to(new_user_session_path) }
      end
    end

    describe "user" do
      describe "/account" do
        before { visit '/account' }
        it { should require_login }
      end
    end
  end

  # checks ownership
  # reviews [edit, update, delete]
  describe "ownership check performed for signed-in users" do
    before { valid_signin user }
    #sign_in user

    context "user owns the resource" do
      describe "reviews#edit" do
        before { visit edit_review_path(review) }
        it { status_code.should == 200 }
      end

      describe "reviews#update" do
        before { patch review_path(review) }
        it { status_code.should == 200 }
      end

      describe "reviews#update" do
        before { put review_path(review) }
        it { status_code.should == 200 }
      end

      describe "reviews#delete" do
        before { delete review_path(review) }
        it { status_code.should == 200 }
      end
    end

    context "user does not own the resource" do
      let!(:non_owned_review) { create_review }

      describe "reviews#edit" do
        before { visit edit_review_path(non_owned_review) }
        it { status_code.should == 403 }
      end

      # strange behavior occurs for the following tests
      # I originally expected a 403 forbidden but I think because the authenticity_token
      # is not being passed in as part of the request rails terminates the session
      # then, because we are submitting to a sign-in required action we get a redirect
      # to the log in page
      # proper testing of review ownership is in the controller specs

      describe "reviews#update" do
        specify {
          patch review_path(non_owned_review)
          expect(response).to redirect_to(new_user_session_path)
        }
      end

      describe "reviews#update" do
        specify {
          put review_path(non_owned_review)
          expect(response).to redirect_to(new_user_session_path)
        }
      end

      describe "reviews#delete" do
        specify {
          reviews_before = Review.count
          delete review_path(non_owned_review)
          reviews_after = Review.count
          expect(response).to redirect_to(new_user_session_path)
          expect(reviews_before).to eq reviews_after
        }
      end
    end
  end
end
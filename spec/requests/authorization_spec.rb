require 'spec_helper'

describe 'authorization required pages' do

  subject{page}

  describe "for non-signed-in users" do
    let(:user) { FactoryGirl.create(:user) }
    let(:review) { FactoryGirl.create(:review) }

    describe "accessing reviews#new" do
      before { visit new_review_path }
      it { should require_login }
    end

    describe "accessing reviews#create" do
      before { post reviews_path }
      specify { expect(response).to redirect_to(new_user_session_path) }
    end

    describe "accessing reviews#edit" do
      before { patch review_path(:review) }
      specify { expect(response).to redirect_to(new_user_session_path) }
    end

    describe "accessing reviews#edit" do
      before { put review_path(:review) }
      specify { expect(response).to redirect_to(new_user_session_path) }
    end

    describe "accessing users#show" do
      before { visit account_path }
      it { should require_login }
    end
  end
end
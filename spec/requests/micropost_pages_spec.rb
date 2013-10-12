require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { valid_signin user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    let! (:micropost_to_delete) { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "microposts created by the user should have a delete link" do
        should have_link 'delete', href: micropost_path(micropost_to_delete)
      end

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end

      describe "microposts by another user" do
        let(:user2) { FactoryGirl.create(:user) }
        let!(:micropost_by_another_user) { FactoryGirl.create(:micropost, user: user2) }

        before do
          visit root_path
        end

        it "should not have a delete link" do
          puts page.body
          should_not have_link 'delete', href: micropost_path(micropost_by_another_user)
        end
      end
    end
  end
end
require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end

  describe "Home page" do
    before { visit root_path }
    let (:heading) { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      let!(:first_post) { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum") }
      let!(:second_post) { FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet") }
      before do
        valid_signin user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      it "should display a count of the users microposts" do
        expect(page).to have_content("2 microposts")
      end

      describe "for a single post" do
        before do
          second_post.destroy
          visit root_path
        end

        it "should pluralize correctly" do
          expect(page).to have_content("1 micropost")
        end
      end

      describe "very long words in microposts" do
        before do
          first_post.content = "a" * 35
          first_post.save
          visit root_path
        end

        it "should be split up" do
          should_not have_content("a" * 35)
        end
      end

      describe "should paginate micro posts" do
        before do
          30.times { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum") }
          visit root_path
        end

        it { should have_selector('div.pagination') }

        describe "clicking the link to page to" do
          before do
            click_link('2', match: :first)
          end

          it "should display the second page of microposts" do
            user.feed.paginate(page: 2).each do |item|
              puts item.attributes
              expect(page).to have_selector("li##{item.id}", text: item.content)
            end
          end
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let (:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    let (:heading) { 'About Us' }
    let(:page_title) { 'About' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }

    let (:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end
end
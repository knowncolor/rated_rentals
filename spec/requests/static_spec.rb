require 'spec_helper'

describe "Static" do

  subject { page }

  describe "loading home page" do
    before { visit root_path }

    it { should have_content('Rated Rentals') }
  end


end

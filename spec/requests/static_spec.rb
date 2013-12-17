require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "root page" do
    before { visit root_path }

    it { should have_content('Find Rental Reviews') }
  end


end

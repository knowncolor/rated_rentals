require 'spec_helper'

include Devise::TestHelpers

describe ReviewsController do
  describe "GET #show" do
    let (:review) { create_review }
    it "assigns the requested review to @review" do
      get :show, id: review
      assigns(:review).should eq(review)
    end

    it "renders the #show view" do
      get :show, id: review
      response.should render_template :show
    end
  end

  describe "DELETE /id" do
    let (:review) { create_review }

    it "deletes the review" do
      expect {
        delete :destroy, id: review
      }.to change(Review, :count).by(1)
    end

    it "renders the #show view" do
      get :show, id: review
      response.should render_template :show
    end
  end

  describe "POST create" do
    let(:user) { create_user }

    before do
      sign_in user
    end

    context "with valid attributes" do
      let(:valid_review_attributes) { review_attributes.merge(address_attributes: address_attributes) }

      it "creates a new review" do
        expect { post :create, review: valid_review_attributes }.to change(Review, :count).by(1)
      end

      it "redirects to the new review" do
        post :create, review: valid_review_attributes
        response.should redirect_to Review.last
      end
    end

    describe "with invalid attributes" do
      shared_examples_for "failed save" do |params|
        it "does not save the new review" do
          expect { post :create, review: params }.to_not change(Review, :count)
        end

        it "re-renders the new method" do
          post :create, review: params
          response.should render_template :new
        end
      end

      context "review attributes are invalid" do
        it_should_behave_like 'failed save', review_attributes(start_date: 'fdsfdsfd').merge(address_attributes: address_attributes)
      end

      context "address attributes are invalid" do
        it_should_behave_like 'failed save', review_attributes.merge(address_attributes: address_attributes(route: ''))
      end
    end

    context "with an address which matches an existing one" do
      before do
        @address = create_address
        @address_attributes = address_attributes_for(@address)
      end

      it "with all fields" do
        expect {
          existing_address = review_attributes.merge(address_attributes: @address_attributes)
          post :create, review: existing_address
        }.to change(Address, :count).by(0)
      end

      it "with only the required matching values" do
        expect {
          existing_address = review_attributes.merge(address_attributes: @address_attributes.update(country: "new country", postal_town: "new postal town"))
          post :create, review: existing_address
        }.to change(Address, :count).by(0)
      end

      it "with a blank flat number" do
        expect {
          nil_flat_address = review_attributes.merge(address_attributes: @address_attributes.update(flat_number: nil))
          post :create, review: nil_flat_address
          post :create, review: nil_flat_address
        }.to change(Address, :count).by(1)
      end
    end

    context "with an address which doesnt match an existing one" do
      before do
        @address = create_address
        @address_attributes = address_attributes_for(@address)
      end

      it "doesnt match on flat number" do
        expect {
          new_flat_number = review_attributes.merge(address_attributes: @address_attributes.update(flat_number: "new flat number"))
          post :create, review: new_flat_number
        }.to change(Address, :count).by(1)
      end

      it "doesnt match on street number" do
        expect {
          new_street_number = review_attributes.merge(address_attributes: @address_attributes.update(street_number: "new street number"))
          post :create, review: new_street_number
        }.to change(Address, :count).by(1)
      end

      it "doesnt match on route" do
        expect {
          new_route = review_attributes.merge(address_attributes: @address_attributes.update(route: "new route"))
          post :create, review: new_route
        }.to change(Address, :count).by(1)
      end

      it "doesnt match on postal_code number" do
        expect {
          new_postal_code = review_attributes.merge(address_attributes: @address_attributes.update(postal_code: "new postal code"))
          post :create, review: new_postal_code
        }.to change(Address, :count).by(1)
      end

      it "existing flat number is nil" do
        @address.flat_number = nil
        @address.save

        expect {
          non_nil_flat_number = review_attributes.merge(address_attributes: @address_attributes.update(flat_number: "new flat number"))
          post :create, review: non_nil_flat_number
        }.to change(Address, :count).by(1)
      end

      it "new flat number is nil" do
        expect {
          nil_flat_number = review_attributes.merge(address_attributes: @address_attributes.update(flat_number: nil))
          post :create, review: nil_flat_number
        }.to change(Address, :count).by(1)
      end
    end
  end

  describe "patch/put update" do
    before do
      @review = create_review
      @address = @review.address
      @review_attributes = review_attributes_for(@review)
      @address_attributes = address_attributes_for(@address)
      sign_in @review.user
    end

    describe "with valid attributes" do
      let(:new_building_comments) { "new building comments" }
      let(:updated_review_attributes) { @review_attributes.update(building_comments: new_building_comments).merge(address_attributes: @address_attributes) }

      it "updates a review" do
        patch :update, id: @review.id, review: updated_review_attributes
        assigns(:review).should eq(@review)
        expect(@review.reload.building_comments).to eq new_building_comments
      end

      it "shows the updated review" do
        patch :update, id: @review.id, review: updated_review_attributes
        response.should redirect_to @review
      end
    end

    describe "with invalid attributes" do
      shared_examples_for "failed update" do |params|
        it "does not update the review" do
          patch :update, id: @review.id, review: invalid_params
          assigns(:review).should eq(@review)
          expect(@review.updated_at).to eq @review.reload.updated_at
        end

        it "re-renders the edit method" do
          patch :update, id: @review.id, review: invalid_params
          response.should render_template :edit
        end
      end

      context "review attributes are invalid" do
        let (:invalid_params) { @review_attributes.update(start_date: 'fdsfdsfd').merge(address_attributes: @address_attributes) }
        it_should_behave_like 'failed update'
      end

      context "address attributes are invalid" do
        let (:invalid_params) { @review_attributes.merge(address_attributes: @address_attributes.update(route: '')) }
        it_should_behave_like 'failed update'
      end
    end

    context "with an unchanged address" do
      it "shouldn't create a new address" do
        expect { patch :update, id: @review.id, review: @review_attributes.merge(address_attributes: @address_attributes) }.to_not change(Address, :count)
      end

      it "shouldn't update the existing address" do
        before_updated_at = @address.updated_at
        patch :update, id: @review.id, review: @review_attributes.merge(address_attributes: @address_attributes)
        expect(@address.reload.updated_at).to eq before_updated_at
      end
    end

    context "with an address which matches an existing one" do
      before do
        @existing_address = create_address
        @existing_address_attributes = address_attributes_for(@existing_address)
      end

      it "shouldn't update the old address" do
        patch :update, id: @review.id, review: @review_attributes.merge(address_attributes: @existing_address_attributes)
        expect(@address.reload.route).to_not eq @existing_address.route
      end

      it "match on all fields" do
        expect {
          updated_address = @review_attributes.merge(address_attributes: @existing_address_attributes)
          patch :update, id: @review.id, review: updated_address
        }.to change(Address, :count).by(0)
      end

      it "match only on required fields" do
        expect {
          updated_address = @review_attributes.merge(address_attributes: @existing_address_attributes.update(country: "new country", postal_town: "new postal town", decimal_degrees_latitude: 12, decimal_degrees_longitude: 14))
          patch :update, id: @review.id, review: updated_address
        }.to change(Address, :count).by(0)
      end

      it "matching blank flat numbers" do
        @existing_address.flat_number = nil
        @existing_address.save

        expect {
          nil_flat_address = @review_attributes.merge(address_attributes: @existing_address_attributes.update(flat_number: nil))
          patch :update, id: @review.id, review: nil_flat_address
        }.to change(Address, :count).by(0)
      end
    end

    context "with an address which doesnt match an existing one" do
      let (:new_route) { "new route" }
      it "should create a new address assigned to the review" do
        expect {
          patch :update, id: @review.id, review: @review_attributes.merge(address_attributes: @address_attributes.update(route: new_route))
        }.to change(Address, :count).by(1)

        expect(@review.reload.address_id).to_not eq @address.id
      end

      it "shouldn't update the old address" do
        patch :update, id: @review.id, review: @review_attributes.merge(address_attributes: @address_attributes.update(route: new_route))
        expect(@address.reload.route).to_not eq new_route
      end

      describe "test each attribute" do
        it "doesnt match on flat number" do
          expect {
            new_flat_number = @review_attributes.merge(address_attributes: @address_attributes.update(flat_number: "new flat number"))
            patch :update, id: @review.id, review: new_flat_number
          }.to change(Address, :count).by(1)
        end

        it "doesnt match on street number" do
          expect {
            new_street_number = @review_attributes.merge(address_attributes: @address_attributes.update(street_number: "new street number"))
            patch :update, id: @review.id, review: new_street_number
          }.to change(Address, :count).by(1)
        end

        it "doesnt match on route" do
          expect {
            new_route = @review_attributes.merge(address_attributes: @address_attributes.update(route: "new route"))
            patch :update, id: @review.id, review: new_route
          }.to change(Address, :count).by(1)
        end

        it "doesnt match on postal_code number" do
          expect {
            new_postal_code = @review_attributes.merge(address_attributes: @address_attributes.update(postal_code: "new postal code"))
            patch :update, id: @review.id, review: new_postal_code
          }.to change(Address, :count).by(1)
        end

        it "existing flat number is nil" do
          @address.flat_number = nil
          @address.save

          expect {
            non_nil_flat_number = @review_attributes.merge(address_attributes: @address_attributes.update(flat_number: "new flat number"))
            patch :update, id: @review.id, review: non_nil_flat_number
          }.to change(Address, :count).by(1)
        end

        it "new flat number is nil" do
          expect {
            nil_flat_number = @review_attributes.merge(address_attributes: @address_attributes.update(flat_number: nil))
            patch :update, id: @review.id, review: nil_flat_number
          }.to change(Address, :count).by(1)
        end
      end
    end
  end
end

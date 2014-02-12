class ReviewsController < ApplicationController
  include ApplicationHelper

  before_filter :ensure_signed_in,
                :only => [:destroy, :new, :create, :update, :edit]

  skip_before_filter :verify_authenticity_token

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id

    # if the review isn't valid don't do any existing address lookup
    if !@review.valid?
      render 'new'
      return
    end

    merge_in_existing_address @review

    if @review.save
      flash[:success] = "Awesome! Thanks for adding a review."
      redirect_to @review
    else
      render 'new'
    end
  end

  def destroy
    @review = Review.find(params[:id])
    raise SecurityTransgression unless @review.is_owner?(current_user)

    @review.destroy

    redirect_to current_user
  end

  def edit
    @review = Review.find(params[:id])
    raise SecurityTransgression unless @review.is_owner?(current_user)
  end

  def new
    @review = Review.new
    @review.address = Address.new
  end

  def show
    @review = Review.find(params[:id])
  end

  def update
    sanitized_params = review_params
    @review = Review.find(params[:id])
    raise SecurityTransgression unless @review.is_owner?(current_user)

    address_changed = will_address_change(@review.address, sanitized_params[:address_attributes])
    sanitized_params.except!(:address_attributes) if !address_changed

    @review.assign_attributes(sanitized_params)

    # if the review isn't valid don't do any existing address lookup
    if !@review.valid?
      render 'edit'
      return
    end

    address_id_before_merge = @review.address_id
    merge_in_existing_address @review

    # if an address is changed create a new record instead of updating it
    if @review.address_id == address_id_before_merge && address_changed
      @review.address = @review.address.dup
    end

    if @review.save
      redirect_to review_path(@review)
    else
      render 'edit'
    end
  end

  private
  def review_params
    params.require(:review).permit(:user_id, :address_id, :start_date, :end_date, :building_rating, :furnishings_rating, :noise_rating, :amenities_rating, :transport_rating,
                                   :building_comments, :furnishings_comments, :noise_comments, :amenities_comments, :transport_comments,
                                   :address_attributes => [:id, :flat_number, :street_number, :route, :postal_town, :postal_code, :country, :decimal_degrees_latitude, :decimal_degrees_longitude])
  end

  def will_address_change(addressRecord, addressParams)
    addressRecord.flat_number != addressParams[:flat_number] ||
        addressRecord.street_number != addressParams[:street_number] ||
        addressRecord.route != addressParams[:route] ||
        addressRecord.postal_code != addressParams[:postal_code] ||
        addressRecord.postal_town != addressParams[:postal_town] ||
        addressRecord.country != addressParams[:country] ||
        addressRecord.decimal_degrees_latitude != addressParams[:decimal_degrees_latitude] ||
        addressRecord.decimal_degrees_longitude != addressParams[:decimal_degrees_longitude]
  end

  # replace the address on the review with an existing record if we have one
  def merge_in_existing_address(review)
    existing_address = Address.find_by postal_code: review.address.postal_code,
                                        route: review.address.route,
                                        street_number: review.address.street_number,
                                        flat_number: review.address.flat_number

    review.address = existing_address if existing_address
  end
end

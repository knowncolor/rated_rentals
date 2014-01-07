class ReviewsController < ApplicationController
  include ApplicationHelper

  before_filter :ensure_signed_in,
                :only => [:destroy, :new, :create, :update]

  def create
    @review = Review.new(user_params)

    # if the review isnt valid don't do any existing address lookup just yet
    if !@review.valid?
      render 'new'
      return
    end

    merge_in_existing_address @review
    @review.user_id = current_user.id

    if @review.save
      flash[:success] = "Awesome! Thanks for adding a review."
      redirect_to @review
    else
      render 'new'
    end
  end

  def new
    @review = Review.new
    @review.address = Address.new
  end

  def show
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    @review.update_attributes(user_params)

    if @review.save
      redirect_to review_path(@review)
    else
      render review_path(@review)
    end
  end

  private
  def user_params
    params.require(:review).permit(:start_date, :end_date, :building_rating, :furnishings_rating, :noise_rating, :amenities_rating, :transport_rating,
                                   :building_comments, :furnishings_comments, :noise_comments, :amenities_comments, :transport_comments,
                                   :address_attributes => [:flat_number, :street_number, :route, :postal_town, :postal_code, :country, :decimal_degrees_latitude, :decimal_degrees_longitude])
  end

  # replace the address on the review with an existing record if we have one
  def merge_in_existing_address(review)
    @existing_address = Address.find_by postal_code: @review.address.postal_code,
                                        route: @review.address.route,
                                        street_number: @review.address.street_number,
                                        flat_number: @review.address.flat_number

    @review.address = @existing_address if @existing_address
  end
end

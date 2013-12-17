class ReviewsController < ApplicationController
  include  ApplicationHelper

  before_filter :ensure_signed_in,
                :only => [:destroy, :new, :create, :update]
  def create
    @review = Review.new(user_params)

    if @review.save
      flash[:success] = "Awesome! Thanks for adding a review."
      redirect_to @review
    else
      render 'new'
    end
  end

  def new
    @review = Review.new
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
    params.require(:review).permit(:street_number, :route, :postal_town, :postal_code, :decimal_degrees_latitude, :decimal_degrees_longitude,
                                   :start_date, :end_date, :building_rating, :furnishings_rating, :noise_rating, :amenities_rating, :transport_rating,
                                   :building_comments, :furnishings_comments, :noise_comments, :amenities_comments, :transport_comments)
  end
end

class ReviewsController < ApplicationController

  def create

    @review = Review.new(user_params)

    if @review.save
      render 'new'
    else
      render 'new'
    end


  end

  def new
    @review = Review.new
  end


  private
  def user_params
    params.require(:review).permit(:street_number, :route, :postal_town, :postal_code, :decimal_degrees_latitude, :decimal_degrees_longitude)
  end
end

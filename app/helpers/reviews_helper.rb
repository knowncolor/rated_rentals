module ReviewsHelper
  def review_title(review)
    "Review of #{review.formatted_address}"
  end
end
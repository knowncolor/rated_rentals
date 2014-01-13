module ReviewsHelper
  def review_title(review)
    "Review of #{review.address.formatted_address}"
  end
end
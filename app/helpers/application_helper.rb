module ApplicationHelper

  def flash_class(level)
    case level
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-danger"
      when :alert then "alert alert-danger"
    end
  end

  def ensure_signed_in
    # just here so I don't forget
    if (!user_signed_in?)
      authenticate_user!
    end
  end

end
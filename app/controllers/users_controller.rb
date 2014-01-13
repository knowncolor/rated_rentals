class UsersController < ApplicationController
  before_filter :authenticate_user!, except: :show

  def show
    # we handle non-logged in user trying to access /account
    if !params[:id] && !user_signed_in?
      authenticate_user!
    end

    id = params[:id] ||= current_user.id
    @user = User.includes(:reviews => :address).find(id)
    @is_current_user = (id.to_s == current_user.id.to_s)
  end
end

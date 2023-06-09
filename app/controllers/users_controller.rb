class UsersController < ApplicationController
  before_action :authenticate_user!, :check_user

  def show
    @user = User.find_by(id: params[:id])
    @orders = Order.where(user_id: @user.id)
  end

  def check_user
    @user = User.find_by(id: params[:id])
    if @user&.id != current_user&.id
      redirect_to root_path
    end
  end
  
end

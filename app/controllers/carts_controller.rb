class CartsController < ApplicationController
  include CartsHelper
  before_action :require_login
  before_action :only_current_cart

  def show
    @items_in_cart = CartItem.where(cart_id:current_user.cart)
  end

  def create

  end

  def update

  end

  def destroy

  end
  
end

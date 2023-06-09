class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :item

  def self.add_cart_item_link(permit_link_params)
  	if CartItem.find_by(cart_id: permit_link_params[:cart_id], item_id: permit_link_params[:item_id]) == nil
  		@new_item_add = CartItem.create(item_id: permit_link_params[:item_id], cart_id: permit_link_params[:cart_id])
  	end
  end
end

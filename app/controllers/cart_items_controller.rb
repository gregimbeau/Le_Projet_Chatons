class CartItemsController < ApplicationController

  def create
    puts "#"*100
    puts params
    puts "#"*100
    @card_item = CartItem.add_cart_item_link(permit_link_params)
    redirect_to request.env["HTTP_REFERER"]
  end

  def update

  end

  def destroy
    puts "#"*100
    puts params[:from_cart]
    puts "#"*100

    from_cart = params[:from_cart]

    @item_delete = CartItem.find_by(item_id:params[:id])
    @item_delete.destroy

    redirect_to request.env["HTTP_REFERER"]

  end

  private

  def permit_link_params
    params.require(:cart_item).permit(:item_id, :cart_id)
  end

end

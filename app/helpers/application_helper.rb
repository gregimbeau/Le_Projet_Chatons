module ApplicationHelper
  def create_cart_to_current_user
    if current_user != nil && current_user.cart == nil
      cart = Cart.create(user_id: current_user.id)
    end
  end

  def add_zero(price)
    price_str = price.to_s
    if price_str.split('.').last.size < 2
      price_str.insert((price_str.length),'0')
    end
    return price_str
  end

end

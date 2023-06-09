class CheckoutController < ApplicationController

  def create
    @orders = Item.find(params[:orders])
    session[:orders] = @orders

    @total_amount = params[:total_amount].to_d;
    session[:total_amount] = @total_amount

    @cart_id = current_user.cart.id
    session[:cart_id] = @cart_id



    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: 'eur',
            unit_amount: (@total_amount*100).to_i,
            product_data: {
              name: 'Rails Stripe Checkout',
            },
          },
          quantity: 1
        },
      ],
      mode: 'payment',
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: checkout_cancel_url
    )
   
    redirect_to @session.url, allow_other_host: true
  end


  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
    # Récupérer les ID nécessaires depuis la session
    @orders = session[:orders]
    @cart_id = session[:cart_id]

    # Créer les orders_items
    @order = Order.create!(user_id: current_user.id)
    @orders.each do |item|
      item_id = item["id"]
      order_item = OrderItem.create!(item_id: item_id,order_id:@order.id)
    end

    # Vider le panier
    @orders.each do |item|
      item_id = item["id"]
      cart_item = CartItem.find_by(item_id:item_id, cart_id: @cart_id)
      cart_item.delete
    end

    puts session[:total_amount]
    puts session[:cart_id]
    puts "laalalalalalaall"
    puts "*"*100
    
    
    
    # Effacer l'ID de l'évènement de la session
    session.delete(:orders)
    session.delete(:total_amount)
    session.delete(:cart_id)

    # Forcer le rechargement des données de l'utilisateur pour prendre en compte la nouvelle commande
    current_user.reload
  end


  def cancel
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
  end

end

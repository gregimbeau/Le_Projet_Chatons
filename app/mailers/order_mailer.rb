class OrderMailer < ApplicationMailer
  default from: "gregimbeau@gmail.com"

  def order_confirmation(user)
    @user = user
    @url = "http://monsite.fr/login"
    mail(to: @user.email, subject: "Merci pour votre commande !")
  end

  def admin_order_notification(user)
    @user = user
    @url = "http://monsite.fr/admin"
    mail(to: "adminpcthp@yopmail.com", subject: "Nouvelle commande !")
  end
end

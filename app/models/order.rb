class Order < ApplicationRecord
  after_create :send_confirmation_email

  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items

  def send_confirmation_email
    OrderMailer.order_confirmation(self.user).deliver_now
    OrderMailer.admin_order_notification(self.user).deliver_now
  end
end

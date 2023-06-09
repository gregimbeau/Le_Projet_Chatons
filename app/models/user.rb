class User < ApplicationRecord
  after_create :send_welcome
  has_one :cart
  has_many :orders, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_reader :password_changed
  def password=(new_password)
    @password_changed = true unless new_password.blank?
    super(new_password)
  end

  after_update_commit :send_password_change_email, if: :password_changed

  def ordered_item?(item)
    CartItem.all.each do |i|
      if (item.id == i.item_id)
        return true
      end
    end
    return false
  end
  
  private

  def send_welcome
    UserMailer.welcome(self).deliver_now
  end


  def send_password_change_email
    UserMailer.password_changed(self).deliver_now
  end

end

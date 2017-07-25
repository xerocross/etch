class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  after_create :initialize_brain
  has_many :flashcards
  has_many :keywords
  has_one :brain
  has_many :help_notifications
  validate :check_stripe_id_not_null
  has_many :tips, through: :help_notifications
  
  
  
  def subscribe(payment_token)
    begin
      customer = Stripe::Customer.create(
        :email => self.email,
        :source => payment_token
      )

      Stripe::Subscription.create(
        :customer => customer.id,
        :plan => "basic-monthly",
        :trial_period_days => 30
      )
      self.stripe_id = customer.id
      self.payment_token = payment_token
    rescue Stripe::CardError => e
      self.stripe_id = 'null'
      self.payment_token = 'null'
    end
  end
  
  def change_payment_info(payment_token)
    begin
      cu = Stripe::Customer::retrieve(self.stripe_id)
      cu.source = payment_token
      cu.save;
      self.payment_token = payment_token
    rescue
      self.payment_token = 'null'
    end
  end
  
  def unsubscribe
    begin
      customer = Stripe::Customer.retrieve(self.stripe_id)
      subscription = Stripe::Subscription.retrieve(customer.subscriptions.first.id)
      subscription.delete(:at_period_end => true)
      self.cancel_at_end = true;
    rescue
      self.cancel_at_end = false;
    end
  end
  
  def initialize_brain
    brain = Brain.new()
    brain.user = self
    brain.save!
    self.brain_id = brain.id
  end
  
  
  def print_email (max)
    str = self.email
    if str.length > max
      local = str.split("@").first
      str = local
    end
    if str.length > max
      subMax = max - 3
      str = str[0..subMax] + '&hellip;';
    end
    str
  end
  
  protected
  
  def check_stripe_id_not_null
    errors.add(:stripe_id, "is invalid") if self.stripe_id == 'null'
    errors.add(:payment_token, "is invalid") if self.payment_token == 'null'
  end

end

class EtchController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:hook]
  before_action :authenticate, only: [:contact_us, :email_us]
  
  def options
    @no_context = true
  end
  
  def welcome
    if user_signed_in?
      redirect_to etch_options_path
    end
  end
  
  def about
    @back = root_path
  end
  
  def xerocross
    @back = root_path
  end
  
  def contact_us
    @back = root_path
  end
  
  def email_us
    begin
      RestClient.post "https://api:key-a0dc14ad9fcf4b2de100f409bb4124eb"\
      "@api.mailgun.net/v3/mail.xeroetch.com/messages",
      :from => "<#{@user.email}>",
      :to => "Adam <adam.cross.jobhunt@gmail.com>",
      :subject => "Etch: #{params[:subject]}",
      :text => params[:message]
      redirect_to root_path, notice: 'Email was sent.'
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
      redirect_to root_path, notice: '#{e.response}'
    end
    
  end
  
  def hook
    endpoint_secret = 'whsec_wHWfD1PLCfF3nu6gWWpk35QDnKTPRtWf'
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      render status: 400
      return
    rescue
      # Invalid signature
      render status: 400
      return
    end
    #event = JSON.parse(request.body.read)
    returnHash = {}
    if event.type == "invoice.payment_failed"
      puts "amount due: #{event.data.object.amount_due}"
      customerId = event.data.object.customer
      returnHash[:id] = customerId
      returnHash[:type] = event.type
      user.subscription_expiration = Time.now + 33.days;
    end
    
    if event.type == "invoice.payment_succeeded"
      customerId = event.data.object.customer
      u = User.find_by_stripe_id(customerId)
      if !u.nil?
        if u.subscription_expiration.nil?
          u.subscription_expiration = DateTime.now
        end
        u.subscription_expiration = u.subscription_expiration + 30.days
        u.save
      end
    end
    
    if event.type == "customer.subscription.trial_will_end"
      customerId = event.data.object.customer
      u = User.find_by_stripe_id(customerId)
      puts u.email
      SubscriptionNoticeMailer.end_trial(u.email, event, u).deliver if !u.nil?
    end

    if event.type == "invoice.payment_succeeded"
      customerId = event.data.object.customer
      u = User.find_by_stripe_id(customerId)
      puts u.email
      SubscriptionNoticeMailer.invoice_payment_succeeded(u.email, event, u).deliver if !u.nil?
    end
    
    if event.type == "charge.failed"
      customerId = event.data.object.customer
      u = User.find_by_stripe_id(customerId)
      SubscriptionNoticeMailer.invoice_failure(u.email, event, u).deliver if !u.nil?
    end
    
    if event.type == "customer.subscription.updated"
      if event.data.object.cancel_at_period_end == true
        customerId = event.data.object.customer
        u = User.find_by_stripe_id(customerId)
        SubscriptionNoticeMailer.termination(u.email, event, u).deliver if !u.nil?
      end
    end
    
    begin
      RestClient.post "https://api:key-a0dc14ad9fcf4b2de100f409bb4124eb"\
      "@api.mailgun.net/v3/mail.xeroetch.com/messages",
      :from => "Adam <adam@mail.xeroetch.com>",
      :to => "Adam <adam.cross.jobhunt@gmail.com>",
      :subject => "Etch Event: #{event.type}",
      :text => "Event: #{event.type}."
    rescue RestClient::ExceptionWithResponse => e
     puts e.response
    end
    
    render json: returnHash
  end
  
  
end

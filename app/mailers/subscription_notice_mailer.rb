class SubscriptionNoticeMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_notice_mailer.end_trial.subject
  #
  def end_trial(recipient_email, event, user)
    @user = user
    @trial_end = Time.at(event.data.object.trial_end).to_datetime.strftime("%b %d, %Y")
    mail to: recipient_email, subject: 'Etch Trial Ending Soon'
  end
  
  def invoice_payment_succeeded(recipient_email, event, user)
    @user = user
    @amt = event.data.object.amount_due/100.00
    mail to: recipient_email, subject: 'Etch Payment Succeeded'
  end
  
  def invoice_failure(recipient_email, event, user)
    @user = user
    mail to: recipient_email, subject: 'Etch Payment Failed'
  end
  
  def termination(recipient_email, event, user)
    @user = user
    mail to: recipient_email, subject: 'Etch Subscription Terminated'
  end
  
  
end

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
  
end

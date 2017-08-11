class AccountsController < ApplicationController
  before_action :authenticate
  def options
    @back = root_path
  end
  
  def brain
    @back = account_options_path
    @brain = @user.brain
    render 'brains/show'
  end
  
end

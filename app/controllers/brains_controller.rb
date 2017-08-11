class BrainsController < ApplicationController
  before_action :authenticate

  def show
    @brain = @user.brain
  end
  
  def prognosticate
    learning_constants = params[:learning_constants]
    brain = Brain.new(learning_constants: learning_constants)
    render json: {'prognosticate'=>brain.prognosticate}
  end
  
  def learn(arguments, expected_value)
    
  end
  
  
end

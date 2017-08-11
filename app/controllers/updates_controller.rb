class UpdatesController < ApplicationController
  before_action :authenticate

  def index
    @flashcard = Flashcard.find(params[:flashcard_id])
    @updates = @flashcard.updates
    
  end
  
  
  
  
end

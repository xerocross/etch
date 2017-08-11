class StudyController < ApplicationController
  before_action :authenticate
  def memorize
    @angular_controller = 'cardReviewer'
    @back = study_path
    @path = flashcards_path(format: :json, params: {'memorize'=> true})
    render 'review'
  end
  

  def review
    @angular_controller = 'cardReviewer'
    @back = study_path
    @path = flashcards_path(format: :json,params:{'review'=> true})
    render 'review'
  end
  
  def query
    @back = study_path
    @no_context = true
    render 'browse_query_form'
  end
  
  
  def browse
    if params[:keywords].present?
      @angular_controller = 'cardReviewer'
      @no_context = true
      @back = study_query_path
      @path = flashcards_path(format: :json,params:{'keywords'=> params[:keywords]})
      render 'review'
    else
      redirect_to study_query_path
    end
  end
  
  def options
    @no_context = true
    @back = root_path
  end
  
  
end
